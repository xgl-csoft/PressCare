import SwiftUI

struct SearchResultView: View {
    @EnvironmentObject private var viewModel: AcupointViewModel
    let query: String
    @State private var appearingCards: Set<UUID> = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "68773F").opacity(0.15),
                    Color(hex: "68773F").opacity(0.08),
                    Color(hex: "68773F").opacity(0.2)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.1),
                    Color.clear
                ]),
                center: .topLeading,
                startRadius: 200,
                endRadius: 700
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                HStack(alignment: .top) {
                    Text("Result: \(query)")
                        .font(.system(.headline, design: .serif))
                        .foregroundColor(Color(hex: "68773F"))
                    Spacer()
                    Text("We found \(viewModel.filteredAcupoints.count) Relative Acupoints")
                        .font(.system(.subheadline, design: .serif))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView("Searching In Progress...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                    Spacer()
                } else if let error = viewModel.errorMessage {
                    Spacer()
                    Text(error)
                        .font(.system(.body, design: .serif))
                        .foregroundColor(.secondary)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 16) {
                            ForEach(viewModel.filteredAcupoints) { acupoint in
                                NavigationLink(destination: AcupointDetailView(acupoint: acupoint).environmentObject(viewModel)) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        HStack(alignment: .top) {
                                            Text(acupoint.name)
                                                .font(.system(.headline, design: .serif))
                                                .foregroundColor(Color(hex: "68773F"))
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(acupoint.bodyRegion.rawValue)
                                                .font(.system(.caption, design: .serif))
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color(hex: "859650").opacity(0.2))
                                                .foregroundColor(Color(hex: "859650"))
                                                .clipShape(Capsule())
                                        }
                                        
                                        Text(acupoint.chineseName)
                                            .font(.system(.subheadline, design: .serif))
                                            .foregroundColor(.secondary)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text(acupoint.location)
                                            .font(.system(.body, design: .serif))
                                            .foregroundColor(.secondary)
                                            .lineLimit(2)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(.ultraThinMaterial)
                                            .opacity(0.85)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(hex: "68773F").opacity(0.2), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
                                    .opacity(appearingCards.contains(acupoint.id) ? 1 : 0)
                                    .offset(y: appearingCards.contains(acupoint.id) ? 0 : 20)
                                    .animation(.spring(response: 0.5, dampingFraction: 0.8), value: appearingCards.contains(acupoint.id))
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            appearingCards.insert(acupoint.id)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .padding(.top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Search Result")
                    .font(.system(.headline, design: .serif))
                    .foregroundColor(Color(hex: "68773F"))
            }
        }
        .onDisappear {
            appearingCards.removeAll()
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
