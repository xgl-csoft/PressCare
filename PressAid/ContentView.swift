import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AcupointViewModel()
    @State private var searchText = ""
    @State private var selectedRegion: BodyRegion?
    @State private var scrollOffset: CGFloat = 0
    @State private var appearingCards: Set<UUID> = []
    @State private var selectedTab = 0
    
    init() {
        _viewModel = StateObject(wrappedValue: AcupointViewModel())
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                MainContentView(
                    viewModel: viewModel,
                    searchText: $searchText,
                    selectedRegion: $selectedRegion,
                    appearingCards: $appearingCards
                )
            }
            .environmentObject(viewModel)
            .tabItem {
                Image(systemName: "house.fill")
                Text("Acupoints List")
            }
            .tag(0)
            
            NavigationStack {
                ArAcupointView()
            }
            .environmentObject(viewModel)
            .tabItem {
                Image(systemName: "arkit")
                Text("AR Acupoints")
            }
            .tag(1)
            
            NavigationStack {
                MyProfileView()
            }
            .environmentObject(viewModel)
            .tabItem {
                Image(systemName: "person.fill")
                Text("Tracking Centre")
            }
            .tag(2)
        }
    }
}

struct MainContentView: View {
    let viewModel: AcupointViewModel
    @Binding var searchText: String
    @Binding var selectedRegion: BodyRegion?
    @Binding var appearingCards: Set<UUID>
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack(spacing: 0) {
                FilterView(
                    selectedRegion: $selectedRegion,
                    viewModel: viewModel
                )
                
                AcupointListView(
                    viewModel: viewModel,
                    appearingCards: $appearingCards
                )
            }
            .onChange(of: selectedRegion) { _, newRegion in
                viewModel.filterAcupoints(by: newRegion)
                // 重置appearingCards以触发动画
                appearingCards.removeAll()
            }
        }
        .navigationTitle("My Acupoints List")
        .overlay(Group {
            if viewModel.isLoading {
                ProgressView("Searching...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
            } else if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(.secondary)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .transition(.scale.combined(with: .opacity))
            }
        })
    }
}

struct BackgroundView: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.35),
                Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.25),
                Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.45)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

struct FilterView: View {
    @Binding var selectedRegion: BodyRegion?
    let viewModel: AcupointViewModel
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(title: "All", isSelected: selectedRegion == nil) {
                    withAnimation(.spring(response: 0.3)) {
                        selectedRegion = nil
                        viewModel.filterAcupoints(by: nil)
                    }
                }
                
                ForEach(BodyRegion.allCases, id: \.self) { region in
                    FilterChip(
                        title: LocalizationService.shared.localizedString(region.rawValue),
                        isSelected: selectedRegion == region
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedRegion = region
                            viewModel.filterAcupoints(by: region)
                        }
                    }
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 8)
        .animation(.easeInOut, value: selectedRegion)
    }
}

struct AcupointListView: View {
    let viewModel: AcupointViewModel
    @Binding var appearingCards: Set<UUID>
    @State private var scrollOffset: CGFloat = 0
    @State private var isFirstAppear = true
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    GeometryReader { proxy in
                        Color.clear.preference(
                            key: ScrollOffsetKey.self,
                            value: proxy.frame(in: .named("scroll")).minY
                        )
                    }
                    .frame(height: 0)
                    
                    LazyVStack(spacing: -160) {
                        ForEach(viewModel.filteredAcupoints) { acupoint in
                            GeometryReader { geometry in
                                NavigationLink(destination: AcupointDetailView(acupoint: acupoint).environmentObject(viewModel)) {
                                    AcupointCard(
                                        acupoint: acupoint,
                                        offset: calculateOffset(for: geometry),
                                        scale: calculateScale(for: geometry)
                                    )
                                    .environmentObject(viewModel)
                                }
                            }
                            .frame(height: 220)
                            .padding(.horizontal)
                            .offset(y: calculateVerticalOffset(for: acupoint))
                            .opacity(appearingCards.contains(acupoint.id) ? 1 : 0)
                            .onAppear {
                                if isFirstAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + Double(viewModel.filteredAcupoints.firstIndex(of: acupoint) ?? 0) * 0.1) {
                                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                            _ = appearingCards.insert(acupoint.id)
                                        }
                                    }
                                } else {
                                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                        _ = appearingCards.insert(acupoint.id)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 200)
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetKey.self) { offset in
                    scrollOffset = offset
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        isFirstAppear = false
                    }
                }
            }
        }
    }
    
    private func calculateOffset(for geometry: GeometryProxy) -> CGFloat {
        return 0 // 移除上下浮动效果
    }
    
    private func calculateScale(for geometry: GeometryProxy) -> CGFloat {
        let frame = geometry.frame(in: .named("scroll"))
        let minY = frame.minY
        let screenHeight = UIScreen.main.bounds.height
        
        // 只在卡片移出屏幕时轻微缩小
        if minY < 0 {
            return max(1 - abs(minY) / screenHeight * 0.2, 0.9)
        }
        return 1
    }
    
    private func calculateVerticalOffset(for acupoint: Acupoint) -> CGFloat {
        guard appearingCards.contains(acupoint.id) else { return 50 }
        return 0
    }
}

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.subheadline, design: .serif))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if isSelected {
                            LinearGradient(
                                colors: [
                                    Color(red: 0.408, green: 0.467, blue: 0.325),
                                    Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .strokeBorder(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        } else {
                            Color.gray.opacity(0.1)
                        }
                        
                        if isSelected {
                            RadialGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ]),
                                center: .topLeading,
                                startRadius: 0,
                                endRadius: 20
                            )
                        }
                    }
                )
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Capsule())
                .shadow(color: isSelected ? Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.3) : .clear, radius: 5, x: 0, y: 2)
                .scaleEffect(isSelected ? 1.05 : 1.0)
                .animation(.spring(response: 0.3), value: isSelected)
        }
        .buttonStyle(ScaledButtonStyle())
    }
}

struct ScaledButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct AcupointRow: View {
    let acupoint: Acupoint
    @EnvironmentObject private var viewModel: AcupointViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(acupoint.name.prefix(2) + String(format: "%02d", Int(acupoint.name.dropFirst(2)) ?? 0))
                    .font(.system(.title2, design: .serif, weight: .bold))
                    .foregroundColor(Color(red: 0.408, green: 0.467, blue: 0.325))
                Text(acupoint.chineseName)
                    .font(.system(.headline, design: .serif))
                    .foregroundColor(Color(red: 0.408, green: 0.467, blue: 0.325))
                Text(acupoint.chineseName)
                    .font(.system(.body, design: .serif))
                    .foregroundColor(.secondary)
                Spacer()
                if viewModel.isFavorite(acupoint) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .symbolEffect(.bounce)
                }
                Text(acupoint.bodyRegion.rawValue)
                    .font(.system(.caption, design: .serif))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.ultraThinMaterial)
                    .foregroundColor(Color(red: 0.408, green: 0.467, blue: 0.325))
                    .clipShape(Capsule())
            }
            
            Text(acupoint.description)
                .font(.system(.body, design: .serif))
                .foregroundColor(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 2)
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
                .opacity(0.3)
        )
    }
}

#Preview {
    ContentView()
}
