import SwiftUI

struct AcupointCard: View {
    let acupoint: Acupoint
    let offset: CGFloat
    let scale: CGFloat
    @EnvironmentObject private var viewModel: AcupointViewModel
    @State private var opacity = 0.0
    @State private var gradientStart = UnitPoint(x: 0, y: 0)
    @State private var gradientEnd = UnitPoint(x: 1, y: 1)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 卡片头部
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(acupoint.name.prefix(2) + String(format: "%02d", Int(acupoint.name.dropFirst(2)) ?? 0))
                            .font(.system(.title2, design: .serif, weight: .bold))
                            .foregroundColor(Color(red: 0.408, green: 0.467, blue: 0.325))
                        Text(acupoint.chineseName)
                            .font(.system(.headline, design: .serif))
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                Button(action: { viewModel.toggleFavorite(for: acupoint) }) {
                    Image(systemName: viewModel.isFavorite(acupoint) ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                        .font(.title2)
                }
            }
            
            Spacer()
            
            // 卡片底部
            HStack {
                Text(acupoint.bodyRegion.rawValue)
                    .font(.system(.caption, design: .serif))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.1))
                    .foregroundColor(Color(red: 0.408, green: 0.467, blue: 0.325))
                    .clipShape(Capsule())
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .background(
            ZStack {
                // 添加渐变遮罩效果
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.08),
                                Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.05),
                                Color(red: 0.408, green: 0.467, blue: 0.325).opacity(0.12)
                            ],
                            startPoint: gradientStart,
                            endPoint: gradientEnd
                        )
                    )
                    .opacity(0.8)
                
                // 添加玻璃拟态效果
                RoundedRectangle(cornerRadius: 20)
                    .fill(.ultraThinMaterial)
                    .opacity(0.7)
                
                // 添加光晕效果
                RadialGradient(
                    gradient: Gradient(colors: [
                        Color.white.opacity(0.2),
                        Color.clear
                    ]),
                    center: .topLeading,
                    startRadius: 50,
                    endRadius: 150
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .opacity(0.5)
            }
        )
        .onAppear {
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: true)) {
                gradientStart = UnitPoint(x: 1, y: 1)
                gradientEnd = UnitPoint(x: 0, y: 0)
            }
        }
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
        .offset(y: offset)
        .scaleEffect(scale)
        .opacity(opacity)
        .onAppear {
            withAnimation(.easeOut(duration: 0.6)) {
                opacity = 1.0
            }
        }
    }
}