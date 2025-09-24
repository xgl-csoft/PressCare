import SwiftUI

struct AcupointDetailView: View {
    let acupoint: Acupoint
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var viewModel: AcupointViewModel
    @State private var appeared = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.15),
                    Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.08),
                    Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.2)
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
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with Glass Effect
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(acupoint.name)
                                    .font(.system(size: 40, weight: .bold, design: .serif))
                                    .foregroundStyle(.primary)
                                    .opacity(appeared ? 1 : 0)
                                    .offset(x: appeared ? 0 : -20)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: appeared)
                                Text(acupoint.chineseName)
                                    .font(.system(size: 24, weight: .medium, design: .serif))
                                    .foregroundStyle(.secondary)
                                    .opacity(appeared ? 1 : 0)
                                    .offset(x: appeared ? 0 : -20)
                                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: appeared)
                            }
                            Spacer()
                            Button(action: { 
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                                    viewModel.toggleFavorite(for: acupoint)
                                }
                            }) {
                                Image(systemName: viewModel.isFavorite(acupoint) ? "heart.fill" : "heart")
                                    .foregroundStyle(.red)
                                    .font(.system(size: 28))
                                    .symbolEffect(.bounce, value: viewModel.isFavorite(acupoint))
                            }
                            .opacity(appeared ? 1 : 0)
                            .scaleEffect(appeared ? 1 : 0.8)
                            .animation(.spring(response: 0.6).delay(0.3), value: appeared)
                        }
                        
                        Text(LocalizationService.shared.localizedString(acupoint.bodyRegion.rawValue))
                            .font(.system(.headline, design: .serif))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.ultraThinMaterial, in: Capsule())
                            .foregroundStyle(Color(red: 0.408, green: 0.467, blue: 0.325))
                            .opacity(appeared ? 1 : 0)
                            .offset(y: appeared ? 0 : 10)
                            .animation(.spring(response: 0.6).delay(0.4), value: appeared)
                    }
                    .padding(.bottom, 8)
                    
                    // Location with Glass Effect
                    VStack(alignment: .leading, spacing: 12) {
                        Label(LocalizationService.shared.localizedString("location"), systemImage: "mappin.circle.fill")
                            .font(.system(.headline, design: .serif))
                            .foregroundStyle(Color(red: 0.408, green: 0.467, blue: 0.325))
                        Text(acupoint.location)
                            .font(.system(.body, design: .serif))
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.2), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 20)
                    .animation(.spring(response: 0.6).delay(0.5), value: appeared)
                    
                    // Benefits with Glass Effect
                    VStack(alignment: .leading, spacing: 12) {
                        Label(LocalizationService.shared.localizedString("benefits"), systemImage: "heart.circle.fill")
                            .font(.system(.headline, design: .serif))
                            .foregroundStyle(Color(red: 0.408, green: 0.467, blue: 0.325))
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
                            ForEach(acupoint.benefits.indices, id: \.self) { index in
                                HStack(alignment: .top, spacing: 8) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(Color(red: 0.408, green: 0.467, blue: 0.325))
                                        .font(.system(size: 18))
                                        .frame(width: 24, alignment: .leading)
                                    Text(acupoint.benefits[index])
                                        .font(.system(.body, design: .serif))
                                        .foregroundStyle(.secondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .opacity(appeared ? 1 : 0)
                                .offset(y: appeared ? 0 : 20)
                                .animation(.spring(response: 0.6).delay(0.7 + Double(index) * 0.1), value: appeared)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.2), lineWidth: 1)
                    }
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                    
                    NavigationLink(destination: ArAcupointView()) {
                        HStack(spacing: 8) {
                            Image(systemName: "arkit")
                                .font(.system(size: 20))
                            Text("View in AR")
                                .font(.system(.headline, design: .serif))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.408, green: 0.467, blue: 0.325),
                                    Color(hex: "68773F").opacity(0.8)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color(hex: "68773F").opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .opacity(appeared ? 1 : 0)
                    .scaleEffect(appeared ? 1 : 0.9)
                    .animation(.spring(response: 0.6).delay(0.8), value: appeared)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            withAnimation {
                appeared = true
            }
        }
        .onDisappear {
            appeared = false
        }
    }
}

#Preview {
    NavigationStack {
        AcupointDetailView(acupoint: Acupoint.additionalAcupoints[0])
            .environmentObject(AcupointViewModel())
    }
}
