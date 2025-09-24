import SwiftUI

struct RecommendedAcupoints: Codable, Hashable {
    let conditions: [String]
    let acupointNames: [String]
}

struct Condition: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var name: String
    var severity: Int // 1-5
    var notes: String
    var date: Date
    var recommendedAcupoints: [String]?
}

struct MyProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @EnvironmentObject private var acupointViewModel: AcupointViewModel
    @State private var showingAddCondition = false
    @State private var showingConditionDetail = false
    @State private var selectedCondition: Condition?
    @State private var newConditionName = ""
    @State private var newConditionSeverity = 3
    @State private var newConditionNotes = ""
    
    var body: some View {
        ZStack {
            // 主题渐变背景
            LinearGradient(
                                                  colors: [
                    Color(hex: "68773F").opacity(0.35),
                    Color(hex: "68773F").opacity(0.25),
                    Color(hex: "68773F").opacity(0.45)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // 添加辐射渐变效果
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
            
            List {
                Section {
                    HStack {
                        Image(systemName: "heart.text.square.fill")
                            .font(.system(size: 60))
                            .foregroundColor(Color(hex: "68773F"))
                        
                        VStack(alignment: .leading) {
                            Text("PressCare+")
                                .font(.system(.title, design: .serif))
                            Text("Track your conditions and favorite acupoints")
                                .font(.system(.subheadline, design: .serif))
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 8)
                    .listRowBackground(Color.clear)
                }
                
                Section("Tracked Conditions") {
                    ForEach(viewModel.conditions) { condition in
                        Button(action: {
                            selectedCondition = condition
                            showingConditionDetail = true
                        }) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(condition.name)
                                        .font(.system(.headline, design: .serif))
                                        .foregroundColor(Color(hex: "68773F"))
                                    Spacer()
                                    SeverityView(level: condition.severity)
                                }
                                
                                if !condition.notes.isEmpty {
                                    Text(condition.notes)
                                        .font(.system(.body, design: .serif))
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                }
                                
                                if let recommendedAcupoints = condition.recommendedAcupoints,
                                   !recommendedAcupoints.isEmpty {
                                    Text("\(recommendedAcupoints.count) recommended acupoints")
                                        .font(.system(.caption, design: .serif))
                                        .foregroundColor(Color(hex: "859650"))
                                }
                                
                                Text(condition.date.formatted(date: .abbreviated, time: .shortened))
                                    .font(.system(.caption, design: .serif))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .opacity(0.7)
                        )
                    }
                    .onDelete(perform: viewModel.deleteCondition)
                    
                    Menu {
                        ForEach(viewModel.presetConditions, id: \.name) { preset in
                            Button(preset.name) {
                                viewModel.addPresetCondition(preset)
                            }
                        }
                        Button("Custom Condition") {
                            showingAddCondition = true
                        }
                    } label: {
                        Label("Add Condition", systemImage: "plus.circle.fill")
                            .foregroundStyle(Color(hex: "68773F"))
                    }
                    .listRowBackground(Color.clear)
                }
                
                Section("Favorite Acupoints") {
                    if acupointViewModel.favoriteAcupoints.isEmpty {
                        Text("No favorite acupoints yet")
                            .foregroundColor(.secondary)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(acupointViewModel.favoriteAcupoints) { acupoint in
                            NavigationLink(destination: AcupointDetailView(acupoint: acupoint).environmentObject(acupointViewModel)) {
                                HStack {
                                    Text(acupoint.name)
                                        .font(.system(.body, design: .serif))
                                        .foregroundColor(Color(hex: "68773F"))
                                    Text(acupoint.chineseName)
                                        .font(.system(.body, design: .serif))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                    Text(acupoint.bodyRegion.rawValue)
                                        .font(.system(.caption, design: .serif))
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color(hex: "859650").opacity(0.2))
                                        .foregroundColor(Color(hex: "859650"))
                                        .clipShape(Capsule())
                                }
                            }
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.ultraThinMaterial)
                                    .opacity(0.7)
                            )
                        }
                    }
                }
                
                Section("App Settings") {
                    Toggle("Enable Notifications", isOn: $viewModel.notificationsEnabled)
                        .font(.system(.body, design: .serif))
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .opacity(0.7)
                        )
                    Toggle("Use Body Tracking", isOn: $viewModel.bodyTrackingEnabled)
                        .font(.system(.body, design: .serif))
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .opacity(0.7)
                        )
                    Toggle("Save AR Screenshots", isOn: $viewModel.saveARScreenshots)
                        .font(.system(.body, design: .serif))
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.ultraThinMaterial)
                                .opacity(0.7)
                        )
                }
                
                Section {
                    NavigationLink(destination: WelcomeView()) {
                        HStack {
                            Image(systemName: "arrow.backward.circle.fill")
                                .font(.system(size: 20))
                            Text("返回欢迎页面")
                                .font(.system(.body, design: .serif))
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color(hex: "68773F"))
                    }
                    .listRowBackground(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ultraThinMaterial)
                            .opacity(0.7)
                    )
                }
            }
            .scrollContentBackground(.hidden)
        }
        .sheet(isPresented: $showingAddCondition) {
            NavigationStack {
                ZStack {
                    // 主题渐变背景
                    LinearGradient(
                        colors: [
                            Color(hex: "68773F").opacity(0.3),
                            Color(hex: "68773F").opacity(0.2),
                            Color(hex: "68773F").opacity(0.4)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .ignoresSafeArea()
                    
                    // 添加辐射渐变效果
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
                        VStack(spacing: 20) {
                            // 名称输入
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Condition Name")
                                    .font(.system(.headline, design: .serif))
                                    .foregroundStyle(Color(hex: "68773F"))
                                TextField("Enter condition name", text: $newConditionName)
                                    .font(.system(.body, design: .serif))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .padding(.horizontal, 4)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(hex: "68773F").opacity(0.2), lineWidth: 1)
                            )
                            
                            // 严重程度选择
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Severity")
                                    .font(.system(.headline, design: .serif))
                                    .foregroundStyle(Color(hex: "68773F"))
                                
                                Text("Level: \(newConditionSeverity)")
                                    .font(.system(.subheadline, design: .serif))
                                    .foregroundStyle(.secondary)
                                
                                HStack(spacing: 16) {
                                    ForEach(1...5, id: \.self) { level in
                                        Button(action: {
                                            withAnimation(.spring(response: 0.3)) {
                                                newConditionSeverity = level
                                            }
                                        }) {
                                            Circle()
                                                .fill(level <= newConditionSeverity ? Color(hex: "68773F") : Color.gray.opacity(0.3))
                                                .frame(width: 32, height: 32)
                                                .overlay(
                                                    Text("\(level)")
                                                        .font(.system(.body, design: .serif))
                                                        .foregroundColor(level <= newConditionSeverity ? .white : .gray)
                                                )
                                                .scaleEffect(level == newConditionSeverity ? 1.2 : 1.0)
                                                .shadow(color: level <= newConditionSeverity ? Color(hex: "68773F").opacity(0.3) : .clear, radius: 5)
                                        }
                                        .animation(.spring(response: 0.3), value: newConditionSeverity)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(hex: "68773F").opacity(0.2), lineWidth: 1)
                            )
                            
                            // 备注输入
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Notes")
                                    .font(.system(.headline, design: .serif))
                                    .foregroundStyle(Color(hex: "68773F"))
                                TextField("Add any additional notes", text: $newConditionNotes, axis: .vertical)
                                    .font(.system(.body, design: .serif))
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .lineLimit(3...6)
                                    .padding(.horizontal, 4)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color(hex: "68773F").opacity(0.2), lineWidth: 1)
                            )
                        }
                        .padding()
                    }
                }
                .navigationTitle("Add Condition")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showingAddCondition = false
                        }
                        .foregroundStyle(Color(hex: "68773F"))
                    }
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Add") {
                            Task {
                                // 使用LLMService推荐穴位
                                if let recommendedAcupoints = try? await LLMService.shared.recommendAcupoints(forSymptoms: newConditionName + " " + newConditionNotes) {
                                    viewModel.addCondition(
                                        name: newConditionName,
                                        severity: newConditionSeverity,
                                        notes: newConditionNotes,
                                        recommendedAcupoints: recommendedAcupoints
                                    )
                                } else {
                                    viewModel.addCondition(
                                        name: newConditionName,
                                        severity: newConditionSeverity,
                                        notes: newConditionNotes
                                    )
                                }
                                showingAddCondition = false
                                newConditionName = ""
                                newConditionSeverity = 3
                                newConditionNotes = ""
                            }
                        }
                        .disabled(newConditionName.isEmpty)
                        .foregroundStyle(Color(hex: "68773F"))
                    }
                }
            }
            .presentationDetents([.large])
            .presentationBackground(.ultraThinMaterial)
        }
        .sheet(isPresented: $showingConditionDetail) {
            if let condition = selectedCondition {
                NavigationStack {
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header
                            VStack(alignment: .leading, spacing: 12) {
                                Text(condition.name)
                                    .font(.system(.title, design: .serif))
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Severity")
                                        .font(.system(.subheadline, design: .serif))
                                        .foregroundColor(.secondary)
                                    
                                    HStack(spacing: 16) {
                                        ForEach(1...5, id: \.self) { level in
                                            Button(action: {
                                                if let index = viewModel.conditions.firstIndex(where: { $0.id == condition.id }) {
                                                    var updatedCondition = condition
                                                    updatedCondition.severity = level
                                                    viewModel.conditions[index] = updatedCondition
                                                    viewModel.saveConditions()
                                                }
                                            }) {
                                                Circle()
                                                    .fill(level <= condition.severity ? Color(hex: "68773F") : Color.gray.opacity(0.3))
                                                    .frame(width: 24, height: 24)
                                                    .overlay(
                                                        Text("\(level)")
                                                            .font(.system(.caption, design: .serif))
                                                            .foregroundColor(level <= condition.severity ? .white : .gray)
                                                    )
                                                    .scaleEffect(level == condition.severity ? 1.2 : 1.0)
                                            }
                                            .animation(.spring(response: 0.3), value: condition.severity)
                                        }
                                    }
                                    .padding(.vertical, 8)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            
                            // Notes
                            if !condition.notes.isEmpty {
                                VStack(alignment: .leading, spacing: 8) {
                                    Label("Notes", systemImage: "note.text")
                                        .font(.system(.headline, design: .serif))
                                        .foregroundStyle(Color(hex: "68773F"))
                                    Text(condition.notes)
                                        .font(.system(.body, design: .serif))
                                        .foregroundStyle(.secondary)
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            }
                            
                            // Recommended Acupoints
                            if let recommendedAcupoints = condition.recommendedAcupoints,
                               !recommendedAcupoints.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Label("Recommended Acupoints", systemImage: "sparkles")
                                        .font(.system(.headline, design: .serif))
                                        .foregroundStyle(Color(hex: "68773F"))
                                    
                                    ForEach(recommendedAcupoints, id: \.self) { acupointName in
                                        if let acupoint = acupointViewModel.findAcupoint(byName: acupointName) {
                                            NavigationLink(destination: AcupointDetailView(acupoint: acupoint)) {
                                                HStack {
                                                    VStack(alignment: .leading, spacing: 4) {
                                                        Text(acupoint.name)
                                                            .font(.system(.headline, design: .serif))
                                                        Text(acupoint.chineseName)
                                                            .font(.system(.subheadline, design: .serif))
                                                            .foregroundColor(.secondary)
                                                    }
                                                    Spacer()
                                                    Image(systemName: "chevron.right")
                                                        .foregroundStyle(Color(hex: "859650"))
                                                }
                                                .padding()
                                                .background(Color(hex: "859650").opacity(0.1))
                                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                            }
                        }
                        .padding()
                    }
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showingConditionDetail = false
                            }
                            .foregroundStyle(Color(hex: "68773F"))
                        }
                    }
                }
            }
        }
    }
}

struct ConditionRow: View {
    let condition: Condition
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(condition.name)
                    .font(.system(.headline, design: .serif))
                Spacer()
                SeverityView(level: condition.severity)
            }
            
            if !condition.notes.isEmpty {
                Text(condition.notes)
                    .font(.system(.subheadline, design: .serif))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            if let recommendedAcupoints = condition.recommendedAcupoints,
               !recommendedAcupoints.isEmpty {
                Text("\(recommendedAcupoints.count) recommended acupoints")
                    .font(.system(.caption, design: .serif))
                    .foregroundColor(Color(hex: "68773F"))
            }
            
            Text(condition.date.formatted(date: .abbreviated, time: .shortened))
                .font(.system(.caption, design: .serif))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

struct SeverityView: View {
    let level: Int
    
    var body: some View {
        HStack(spacing: 2) {
            ForEach(1...5, id: \.self) { index in
                Circle()
                    .fill(index <= level ? Color(hex: "68773F") : Color.gray.opacity(0.3))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var conditions: [Condition] = []
    @Published var notificationsEnabled = false {
        didSet {
            UserDefaults.standard.set(notificationsEnabled, forKey: "NotificationsEnabled")
        }
    }
    @Published var bodyTrackingEnabled = true {
        didSet {
            UserDefaults.standard.set(bodyTrackingEnabled, forKey: "BodyTrackingEnabled")
        }
    }
    @Published var saveARScreenshots = true {
        didSet {
            UserDefaults.standard.set(saveARScreenshots, forKey: "SaveARScreenshots")
        }
    }
    
    let presetConditions: [(name: String, recommendedAcupoints: [String])] = [
        ("Headache", ["ST1", "ST2", "ST8"]),
        ("Back Pain", ["BL23", "BL25", "BL40"]),
        ("Insomnia", ["HT7", "SP6", "AN7"]),
        ("Anxiety", ["PC6", "HT7", "YIN TANG"]),
        ("Digestive Issues", ["ST36", "SP6", "CV12"]),
        ("Neck Pain", ["GB20", "BL10", "SI15"]),
        ("Fatigue", ["ST36", "KI3", "SP6"]),
        ("Joint Pain", ["LI4", "LI11", "ST35"])
    ]
    
    init() {
        // Load settings from UserDefaults
        notificationsEnabled = UserDefaults.standard.bool(forKey: "NotificationsEnabled")
        bodyTrackingEnabled = UserDefaults.standard.bool(forKey: "BodyTrackingEnabled")
        saveARScreenshots = UserDefaults.standard.bool(forKey: "SaveARScreenshots")
        
        // Load conditions from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "Conditions"),
           let savedConditions = try? JSONDecoder().decode([Condition].self, from: data) {
            conditions = savedConditions
        }
    }
    
    func addPresetCondition(_ preset: (name: String, recommendedAcupoints: [String])) {
        let condition = Condition(
            name: preset.name,
            severity: 3,
            notes: "",
            date: Date(),
            recommendedAcupoints: preset.recommendedAcupoints
        )
        conditions.append(condition)
        saveConditions()
    }
    
    func addCondition(name: String, severity: Int, notes: String, recommendedAcupoints: [String]? = nil) {
        let condition = Condition(
            name: name,
            severity: severity,
            notes: notes,
            date: Date(),
            recommendedAcupoints: recommendedAcupoints
        )
        conditions.append(condition)
        saveConditions()
    }
    
    func deleteCondition(at offsets: IndexSet) {
        conditions.remove(atOffsets: offsets)
        saveConditions()
    }
    
    func saveConditions() {
        if let data = try? JSONEncoder().encode(conditions) {
            UserDefaults.standard.set(data, forKey: "Conditions")
        }
    }
}

#Preview {
    NavigationStack {
        MyProfileView()
            .environmentObject(AcupointViewModel())
    }
}
