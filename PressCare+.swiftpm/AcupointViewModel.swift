import Foundation
import SwiftUI

@MainActor
class AcupointViewModel: ObservableObject {
    @Published var acupoints: [Acupoint] = []
    @Published var filteredAcupoints: [Acupoint] = []
    @Published var selectedRegion: BodyRegion?
    @Published var favoriteAcupointIds: Set<UUID> = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    init() {
        loadFavorites()
        loadAcupoints()
    }
    
    private func loadAcupoints() {
        acupoints = Acupoint.additionalAcupoints
        filteredAcupoints = acupoints
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: "FavoriteAcupoints"),
           let favorites = try? JSONDecoder().decode(Set<UUID>.self, from: data) {
            favoriteAcupointIds = favorites
        }
    }
    
    private func saveFavorites() {
        if let data = try? JSONEncoder().encode(favoriteAcupointIds) {
            UserDefaults.standard.set(data, forKey: "FavoriteAcupoints")
        }
    }
    
    func toggleFavorite(for acupoint: Acupoint) {
        if favoriteAcupointIds.contains(acupoint.id) {
            favoriteAcupointIds.remove(acupoint.id)
        } else {
            favoriteAcupointIds.insert(acupoint.id)
        }
        saveFavorites()
    }
    
    func isFavorite(_ acupoint: Acupoint) -> Bool {
        favoriteAcupointIds.contains(acupoint.id)
    }
    
    var favoriteAcupoints: [Acupoint] {
        acupoints.filter { favoriteAcupointIds.contains($0.id) }
    }
    
    func filterAcupoints(by region: BodyRegion?) {
        selectedRegion = region
        errorMessage = nil
        isLoading = false
        
        if let region = region {
            filteredAcupoints = acupoints.filter { acupoint in
                return acupoint.bodyRegion == region
            }
        } else {
            filteredAcupoints = acupoints
        }

        objectWillChange.send()
    }
    
    func searchAcupoints(query: String) async {
        if query.isEmpty {
            filterAcupoints(by: selectedRegion)
            return
        }
        
        do {
            isLoading = true
            errorMessage = nil
            objectWillChange.send() 
            let recommendedAcupointNames = try await LLMService.shared.recommendAcupoints(forSymptoms: query)
            let recommendedAcupoints = recommendedAcupointNames.compactMap { name in
                acupoints.first { $0.name == name }
            }
            
            if !recommendedAcupoints.isEmpty {
                filteredAcupoints = recommendedAcupoints
            } else {
                filteredAcupoints = acupoints.filter { acupoint in
                    let matchesRegion = selectedRegion == nil || acupoint.bodyRegion == selectedRegion
                    let matchesSearch = acupoint.name.localizedCaseInsensitiveContains(query) ||
                                      acupoint.chineseName.localizedCaseInsensitiveContains(query) ||
                                      acupoint.description.localizedCaseInsensitiveContains(query) ||
                                      acupoint.location.localizedCaseInsensitiveContains(query) ||
                                      acupoint.benefits.joined().localizedCaseInsensitiveContains(query)
                    return matchesRegion && matchesSearch
                }.prefix(5).map { $0 }
            }

            await MainActor.run {
                isLoading = false
                objectWillChange.send()
            }
            
        } catch {
            await MainActor.run {
                errorMessage = "Unable to get recommendations, switched to normal search mode"
                isLoading = false
                objectWillChange.send()

                filteredAcupoints = acupoints.filter { acupoint in
                    let matchesRegion = selectedRegion == nil || acupoint.bodyRegion == selectedRegion
                    let matchesSearch = acupoint.name.localizedCaseInsensitiveContains(query) ||
                                      acupoint.chineseName.localizedCaseInsensitiveContains(query) ||
                                      acupoint.description.localizedCaseInsensitiveContains(query) ||
                                      acupoint.location.localizedCaseInsensitiveContains(query) ||
                                      acupoint.benefits.joined().localizedCaseInsensitiveContains(query)
                    return matchesRegion && matchesSearch
                }.prefix(5).map { $0 }

                Task { @MainActor in
                    try? await Task.sleep(nanoseconds: 3_000_000_000)
                    self.errorMessage = nil
                    objectWillChange.send()
                }
            }
        }
    }
    
    func findAcupoint(byName name: String) -> Acupoint? {
        acupoints.first { $0.name == name }
    }
}
