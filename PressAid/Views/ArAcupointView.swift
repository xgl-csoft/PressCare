import SwiftUI
import ARKit
import RealityKit

struct ArAcupointView: View {
    @StateObject private var arViewModel = ARViewModel()
    
    var body: some View {
        ZStack {
            ARViewContainer(arViewModel: arViewModel)
                .edgesIgnoringSafeArea(.all)
                .onDisappear {
                    arViewModel.cleanupAR()
                }
            
            VStack {
                Spacer()
                
                // Control Panel
                VStack(spacing: 16) {
                    Text("AR Acupoint Visualization")
                        .font(.system(.title3, design: .serif))
                        .foregroundColor(.white)
                        .shadow(radius: 2)
                    
                    HStack(spacing: 24) {
                        Button(action: arViewModel.resetTracking) {
                            VStack(spacing: 6) {
                                Image(systemName: "arrow.counterclockwise.circle.fill")
                                    .font(.system(size: 24))
                                Text("Reset")
                                    .font(.system(.caption, design: .serif))
                            }
                        }
                        .buttonStyle(.circularAR)
                        
                        Button(action: arViewModel.toggleBodyTracking) {
                            VStack(spacing: 6) {
                                Image(systemName: arViewModel.isBodyTrackingEnabled ? "person.fill.checkmark" : "person.circle.fill")
                                    .font(.system(size: 24))
                                Text(arViewModel.isBodyTrackingEnabled ? "Tracking On" : "Track")
                                    .font(.system(.caption, design: .serif))
                            }
                        }
                        .buttonStyle(.circularAR)
                        
                        Button(action: arViewModel.captureSnapshot) {
                            VStack(spacing: 6) {
                                Image(systemName: "camera.circle.fill")
                                    .font(.system(size: 24))
                                Text("Capture")
                                    .font(.system(.caption, design: .serif))
                            }
                        }
                        .buttonStyle(.circularAR)
                    }
                }
                .padding(.vertical, 20)
                .padding(.horizontal, 24)
                .background(
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color(hex: "68773F").opacity(0.35),
                                Color(hex: "68773F").opacity(0.45),
                                Color(hex: "68773F").opacity(0.35)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                        .scaleEffect(arViewModel.isBodyTrackingEnabled ? 1.05 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: arViewModel.isBodyTrackingEnabled)
                        
                        RadialGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.2),
                                Color.clear
                            ]),
                            center: .topLeading,
                            startRadius: 100,
                            endRadius: 280
                        )
                        .scaleEffect(1.2)
                        .rotationEffect(.degrees(45))
                        .opacity(0.6)
                        .scaleEffect(arViewModel.isBodyTrackingEnabled ? 1.1 : 1.0)
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: arViewModel.isBodyTrackingEnabled)
                        
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .frame(width: 150, height: 150)
                            .blur(radius: 20)
                            .offset(x: -50, y: -25)
                            .scaleEffect(arViewModel.isBodyTrackingEnabled ? 1.15 : 1.0)
                            .opacity(arViewModel.isBodyTrackingEnabled ? 0.15 : 0.1)
                            .animation(.spring(response: 0.4, dampingFraction: 0.8), value: arViewModel.isBodyTrackingEnabled)
                    }
                    .background(.ultraThinMaterial.opacity(0.85))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(hex: "68773F").opacity(0.6),
                                    Color(hex: "68773F").opacity(0.2)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .cornerRadius(20)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { arViewModel.showHelp = true }) {
                    Image(systemName: "questionmark.circle")
                }
            }
        }
        .alert("AR Visualization Help", isPresented: $arViewModel.showHelp) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Point the camera at the body to start tracking. Acupoints will be marked in green on the body. Click the green point to view detailed information.")
        }
        .sheet(isPresented: $arViewModel.showAcupointInfo) {
            if let acupoint = arViewModel.selectedAcupoint {
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
                    
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(acupoint.name)
                                            .font(.system(size: 40, weight: .bold, design: .serif))
                                            .foregroundStyle(.primary)
                                        Text(acupoint.chineseName)
                                            .font(.system(size: 24, weight: .medium, design: .serif))
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Button(action: { arViewModel.showAcupointInfo = false }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundStyle(.gray)
                                    }
                                }
                                
                                Text(LocalizationService.shared.localizedString(acupoint.bodyRegion.rawValue))
                                    .font(.system(.headline, design: .serif))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.ultraThinMaterial, in: Capsule())
                                    .foregroundStyle(Color(hex: "68773F"))
                            }
                            .padding(.bottom, 8)

                            VStack(alignment: .leading, spacing: 12) {
                                Label(LocalizationService.shared.localizedString("location"), systemImage: "mappin.circle.fill")
                                    .font(.system(.headline, design: .serif))
                                    .foregroundStyle(Color(hex: "68773F"))
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
                                    .stroke(Color(hex: "68773F").opacity(0.2), lineWidth: 1)
                            }
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)

                            VStack(alignment: .leading, spacing: 12) {
                                Label(LocalizationService.shared.localizedString("benefits"), systemImage: "heart.circle.fill")
                                    .font(.system(.headline, design: .serif))
                                    .foregroundStyle(Color(hex: "68773F"))
                                LazyVGrid(columns: [GridItem(.flexible(), spacing: 20), GridItem(.flexible(), spacing: 20)], spacing: 20) {
                                    ForEach(acupoint.benefits.indices, id: \.self) { index in
                                        HStack(alignment: .top, spacing: 8) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundStyle(Color(hex: "68773F"))
                                                .font(.system(size: 18))
                                                .frame(width: 24, alignment: .leading)
                                            Text(acupoint.benefits[index])
                                                .font(.system(.body, design: .serif))
                                                .foregroundStyle(.secondary)
                                                .fixedSize(horizontal: false, vertical: true)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            .overlay {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(hex: "68773F").opacity(0.2), lineWidth: 1)
                            }
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                        }
                        .padding(24)
                    }
                }
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            }
        }
    }
}

struct CircularARButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                LinearGradient(
                    colors: [
                        Color(hex: "68773F").opacity(0.9),
                        Color(hex: "68773F").opacity(0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .scaleEffect(configuration.isPressed ? 0.92 : 1.0)
            .animation(.spring(response: 0.3), value: configuration.isPressed)
            .shadow(color: Color(hex: "68773F").opacity(0.3), radius: 5, x: 0, y: 2)
    }
}

extension ButtonStyle where Self == CircularARButtonStyle {
    static var circularAR: CircularARButtonStyle {
        CircularARButtonStyle()
    }
}

struct ARViewContainer: UIViewRepresentable {
    let arViewModel: ARViewModel
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arViewModel.setupAR(arView)
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    static func dismantleUIView(_ uiView: ARView, coordinator: ()) {
        uiView.session.pause()
        uiView.scene.anchors.removeAll()
        uiView.removeFromSuperview()
    }
}

class AcupointMarker: Entity, HasModel, HasCollision {
    var acupoint: Acupoint
    
    init(acupoint: Acupoint, radius: Float = 0.025) {
        self.acupoint = acupoint
        super.init()
        
        self.model = ModelComponent(
            mesh: .generateSphere(radius: radius),
            materials: [SimpleMaterial(
                color: UIColor(Color(hex: "68773F")),
                roughness: 0.05,
                isMetallic: true
            )]
        )
        
        // Add inner glow effect
        let innerGlow = ModelEntity(
            mesh: .generateSphere(radius: radius * 1.3),
            materials: [SimpleMaterial(
                color: UIColor(Color(hex: "68773F")).withAlphaComponent(0.3),
                roughness: 0.6,
                isMetallic: true
            )]
        )
        self.addChild(innerGlow)
        
        let outerGlow = ModelEntity(
            mesh: .generateSphere(radius: radius * 1.8),
            materials: [SimpleMaterial(
                color: .white.withAlphaComponent(0.15),
                roughness: 0.9,
                isMetallic: false
            )]
        )
        self.addChild(outerGlow)
        
        self.generateCollisionShapes(recursive: true)
    }
    
    required init() {
        fatalError("init() has not been implemented")
    }
}

@MainActor
class ARViewModel: NSObject, ObservableObject, UIGestureRecognizerDelegate {
    @Published var isBodyTrackingEnabled = false
    @Published var showHelp = false
    @Published var selectedAcupoint: Acupoint?
    @Published var showAcupointInfo = false
    
    private var arView: ARView?
    private var bodyAnchor: AnchorEntity?
    
    func setupAR(_ arView: ARView) {
        self.arView = arView
        
        guard ARBodyTrackingConfiguration.isSupported else {
            print("Body tracking is not supported on this device")
            return
        }
        
        let config = ARBodyTrackingConfiguration()
        arView.session.run(config)
        
        // Set up environment lighting
        arView.environment.lighting.intensityExponent = 2
        
        // Add coaching overlay
        let coachingOverlay = ARCoachingOverlayView()
        coachingOverlay.session = arView.session
        coachingOverlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        arView.addSubview(coachingOverlay)
    }
    
    private func enableBodyTracking() {
        guard let arView = arView else { return }
        
        bodyAnchor = AnchorEntity(.body)
        arView.scene.addAnchor(bodyAnchor!)
        
        let bodyOutline = ModelEntity(
            mesh: .generatePlane(width: 2.4, depth: 0.08),
            materials: [SimpleMaterial(
                color: UIColor(Color(hex: "68773F")).withAlphaComponent(0.5),
                roughness: 0.3,
                isMetallic: true
            )]
        )
        bodyOutline.position = SIMD3<Float>(0, 0, 0.04)
        
        let innerGlow = ModelEntity(
            mesh: .generatePlane(width: 2.2, depth: 0.15),
            materials: [SimpleMaterial(
                color: UIColor(Color(hex: "68773F")).withAlphaComponent(0.5),
                roughness: 0.25,
                isMetallic: false
            )]
        )
        innerGlow.position = SIMD3<Float>(0, 0, 0.04)
        bodyOutline.addChild(innerGlow)
        
        let outerGlow = ModelEntity(
            mesh: .generatePlane(width: 3.0, depth: 0.06),
            materials: [SimpleMaterial(
                color: UIColor(Color(hex: "859650")).withAlphaComponent(0.3),
                roughness: 0.4,
                isMetallic: true
            )]
        )
        outerGlow.position = SIMD3<Float>(0, 0, 0.02)
        bodyOutline.addChild(outerGlow)

        let edgeGlow = ModelEntity(
            mesh: .generatePlane(width: 3.2, depth: 0.04),
            materials: [SimpleMaterial(
                color: .white.withAlphaComponent(0.25),
                roughness: 0.7,
                isMetallic: false
            )]
        )
        edgeGlow.position = SIMD3<Float>(0, 0, 0.01)
        bodyOutline.addChild(edgeGlow)

        let shimmerEffect = ModelEntity(
            mesh: .generatePlane(width: 2.9, depth: 0.05),
            materials: [SimpleMaterial(
                color: UIColor.white.withAlphaComponent(0.15),
                roughness: 0.1,
                isMetallic: true
            )]
        )
        shimmerEffect.position = SIMD3<Float>(0, 0, 0.05)
        
        shimmerEffect.transform.rotation = simd_quatf(angle: 0, axis: SIMD3<Float>(0, 0, 1))
        
        shimmerEffect.transform.rotation = .init(angle: 0, axis: [0, 0, 1])
        var spin = shimmerEffect.transform
        spin.rotation = .init(angle: .pi * 2, axis: [0, 0, 1])

        shimmerEffect.move(to: spin, relativeTo: shimmerEffect.parent, duration: 8.0, timingFunction: .linear)

        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) { [weak self] in
            self?.startRotationAnimation(for: shimmerEffect)
        }
        bodyOutline.addChild(shimmerEffect)
        
        bodyAnchor?.addChild(bodyOutline)
        

        for acupoint in Acupoint.allAcupoints {

            let marker = ModelEntity(
                mesh: .generateSphere(radius: 0.02),
                materials: [SimpleMaterial(
                    color: UIColor(Color(hex: "68773F")),
                    roughness: 0.2,
                    isMetallic: true
                )]
            )
            marker.name = acupoint.name
            marker.generateCollisionShapes(recursive: true)

            switch acupoint.name {
            case "LU1": // 中府
                marker.position = SIMD3<Float>(0.12, 0.63, 0.08)
            case "LU2": // 云门
                marker.position = SIMD3<Float>(0.13, 0.60, 0.08)
            case "LU3": // 天府
                marker.position = SIMD3<Float>(0.20, 0.48, 0.08)
            case "LU4": // 侠白
                marker.position = SIMD3<Float>(0.18, 0.53, 0.08)
            case "LU5": // 尺泽
                marker.position = SIMD3<Float>(0.22, 0.35, 0.08)
            case "LU6": // 孔最
                marker.position = SIMD3<Float>(0.24, 0.25, 0.08)
            case "LU7": // 列缺
                marker.position = SIMD3<Float>(0.26, 0.15, 0.08)
            case "LU8": // 经渠
                marker.position = SIMD3<Float>(0.27, 0.10, 0.08)
            case "LU9": // 太渊
                marker.position = SIMD3<Float>(0.28, 0.05, 0.08)
            case "LU10": // 鱼际
                marker.position = SIMD3<Float>(0.29, 0.0, 0.08)
            case "LU11": // 少商
                marker.position = SIMD3<Float>(0.30, -0.05, 0.08)
            // 优化面部穴位定位
            case "ST1": // 承泣
                marker.position = SIMD3<Float>(-0.02, 0.85, 0.08)
            case "ST2": // 四白
                marker.position = SIMD3<Float>(-0.03, 0.82, 0.08)
            case "ST3": // 巨髎
                marker.position = SIMD3<Float>(-0.04, 0.80, 0.08)
            case "ST4": // 地仓
                marker.position = SIMD3<Float>(-0.05, 0.78, 0.08)
            case "ST5": // 大迎
                marker.position = SIMD3<Float>(-0.06, 0.76, 0.08)
            case "ST6": // 颊车
                marker.position = SIMD3<Float>(-0.07, 0.74, 0.08)
            case "ST7": // 下关
                marker.position = SIMD3<Float>(-0.06, 0.79, 0.08)
            case "ST8": // 头维
                marker.position = SIMD3<Float>(-0.08, 0.88, 0.08)

            default:
                continue
            }
            
            bodyAnchor?.addChild(marker)
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapGesture.delegate = self
        arView.addGestureRecognizer(tapGesture)
    }
    
    func toggleBodyTracking() {
        isBodyTrackingEnabled.toggle()
        if isBodyTrackingEnabled {
            enableBodyTracking()
        } else {
            disableBodyTracking()
        }
    }
    
    private func disableBodyTracking() {
        bodyAnchor?.removeFromParent()
        bodyAnchor = nil
    }
    
    func cleanupAR() {
        guard let arView = arView else { return }
        
        arView.session.pause()

        arView.scene.anchors.removeAll()
        bodyAnchor?.removeFromParent()
        bodyAnchor = nil

        arView.gestureRecognizers?.forEach { arView.removeGestureRecognizer($0) }

        isBodyTrackingEnabled = false
        selectedAcupoint = nil
        showAcupointInfo = false

        self.arView = nil
    }
    
    func resetTracking() {
        guard let arView = arView else { return }
        
        let config = ARBodyTrackingConfiguration()
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        
        if isBodyTrackingEnabled {
            enableBodyTracking()
        }
    }
    
    func captureSnapshot() {
        guard let arView = arView else { return }
        
        arView.snapshot(saveToHDR: false, completion: { image in
            guard let image = image else { return }
            
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            // Show save success feedback
            DispatchQueue.main.async {
                let feedback = UINotificationFeedbackGenerator()
                feedback.notificationOccurred(.success)
            }
        })
    }
    
    private func startRotationAnimation(for entity: ModelEntity) {
        var spin = entity.transform
        spin.rotation = .init(angle: .pi * 2, axis: [0, 0, 1])
        
        entity.move(to: spin, relativeTo: entity.parent, duration: 8.0, timingFunction: .linear)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8.0) { [weak self] in
            self?.startRotationAnimation(for: entity)
        }
    }
    
    @objc private func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let arView = arView else { return }
        
        let location = recognizer.location(in: arView)
        let results = arView.hitTest(location)
        
        if let result = results.first,
           let entity = result.entity as? ModelEntity,
           let acupointName = entity.name as? String,
           let acupoint = Acupoint.allAcupoints.first(where: { $0.name == acupointName }) {
            let feedback = UIImpactFeedbackGenerator(style: .medium)
            feedback.impactOccurred()
            
            let originalMaterial = entity.model?.materials.first
            entity.model?.materials = [SimpleMaterial(color: .yellow, roughness: 0.3, isMetallic: true)]

            var transform = entity.transform
            transform.scale *= 1.2
            entity.move(to: transform, relativeTo: entity.parent, duration: 0.15)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                entity.model?.materials = [originalMaterial ?? SimpleMaterial(color: UIColor(Color(hex: "68773F")), roughness: 0.2, isMetallic: true)]
                transform.scale /= 1.2
                entity.move(to: transform, relativeTo: entity.parent, duration: 0.15)
            }
            
            selectedAcupoint = acupoint
            showAcupointInfo = true
        }
    }
}

#Preview {
    ArAcupointView()
}
