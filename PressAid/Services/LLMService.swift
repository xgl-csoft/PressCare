import Foundation

class LLMService {
    static let shared = LLMService()
    
    private init() {}
    
    // 症状到功效的映射字典
    private let symptomToBenefitMap: [String: [String]] = [
        "anxiety": ["calming", "relaxing", "soothing", "anxiety relief", "stress relief", "mental peace", "emotional balance", "tranquility", "mental comfort"],
        "sleepless": ["insomnia", "sleep", "relaxing", "calming", "rest", "drowsiness", "sleep quality", "sleep disorder", "night rest"],
        "insomnia": ["sleep", "relaxing", "calming", "rest", "drowsiness", "sleep quality", "sleep disorder", "night rest", "bedtime"],
        "stress": ["calming", "relaxing", "stress relief", "anxiety relief", "tension relief", "mental peace", "emotional balance", "pressure relief"],
        "headache": ["headache", "pain relief", "migraine", "tension", "head discomfort", "head pressure", "cranial pain"],
        "back": ["back pain", "pain relief", "spine", "lumbar", "back muscles", "back stiffness", "back tension", "vertebrae"],
        "sleep": ["sleep", "insomnia", "relaxing", "rest", "drowsiness", "sleep quality", "bedtime", "night rest"],
        "neck": ["neck pain", "stiffness", "pain relief", "cervical", "neck tension", "neck muscles", "neck strain"],
        "shoulder": ["shoulder pain", "stiffness", "pain relief", "shoulder joint", "rotator cuff", "shoulder tension", "shoulder mobility"],
        "fatigue": ["fatigue", "tiredness", "energy", "exhaustion", "weakness", "vitality", "stamina", "strength"],
        "digestion": ["digestion", "stomach", "nausea", "appetite", "gut health", "digestive system", "gastrointestinal"],
        "depression": ["depression", "mood", "emotional balance", "mental health", "emotional well-being", "mood regulation", "psychological"],
        "joint": ["joint pain", "arthritis", "stiffness", "joint mobility", "joint inflammation", "joint health", "articular"],
        "menstrual": ["menstrual pain", "cramps", "period pain", "menstruation", "feminine health", "monthly cycle", "women's health"],
        "respiratory": ["breathing", "cough", "asthma", "respiratory system", "lung function", "airway", "breath", "chest congestion"],
        "dizziness": ["dizziness", "vertigo", "balance", "lightheadedness", "spinning sensation", "stability", "equilibrium"],
        "eye": ["eye strain", "vision", "eye fatigue", "visual acuity", "eye comfort", "eye health", "optical"],
        "appetite": ["appetite", "digestion", "stomach", "hunger", "eating", "nutrition", "dietary"],
        "nausea": ["nausea", "vomiting", "stomach", "queasiness", "motion sickness", "stomach discomfort"],
        "concentration": ["focus", "attention", "mental clarity", "cognitive function", "mental focus", "alertness", "mindfulness"],
        "memory": ["memory", "mental clarity", "cognitive", "recall", "brain function", "mental acuity", "cognitive ability"],
        "immunity": ["immune system", "resistance", "health", "immune function", "defense system", "body protection", "wellness"],
        "circulation": ["blood circulation", "flow", "circulation", "vascular health", "blood flow", "cardiovascular"],
        "cold": ["common cold", "flu", "fever", "respiratory infection", "sinus", "nasal congestion", "sore throat"],
        "allergy": ["allergy", "hay fever", "rhinitis", "allergic reaction", "seasonal allergies", "histamine response"]
    ]
    
    func recommendAcupoints(forSymptoms symptoms: String) async throws -> [String] {
        // 获取所有穴位
        let allAcupoints = Acupoint.additionalAcupoints
        
        // 将用户输入的症状按关键词拆分
        let keywords = symptoms.components(separatedBy: CharacterSet(charactersIn: ",.，。 "))
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
        
        // 为每个穴位计算匹配分数
        var acupointScores: [(name: String, score: Int)] = []
        
        for acupoint in allAcupoints {
            var score = 0
            
            // 检查穴位名称和中文名称是否匹配关键词
            for keyword in keywords {
                if acupoint.name.localizedCaseInsensitiveContains(keyword) {
                    score += 3 // 穴位名称匹配权重最高
                }
                if acupoint.chineseName.localizedCaseInsensitiveContains(keyword) {
                    score += 3 // 中文名称匹配权重同样最高
                }
                
                // 使用症状映射表增强匹配
                if let relatedBenefits = symptomToBenefitMap[keyword] {
                    for benefit in acupoint.benefits {
                        let benefitLower = benefit.lowercased()
                        for relatedBenefit in relatedBenefits {
                            if benefitLower.contains(relatedBenefit.lowercased()) {
                                score += 4 // 症状映射匹配给予更高权重
                                break
                            }
                        }
                    }
                }
                
                // 检查穴位的功效是否直接匹配关键词
                for benefit in acupoint.benefits {
                    if benefit.localizedCaseInsensitiveContains(keyword) {
                        score += 2 // 功效直接匹配权重次之
                    }
                }
                
                // 检查描述是否匹配
                if acupoint.description.localizedCaseInsensitiveContains(keyword) {
                    score += 1 // 描述匹配权重最低
                }
            }
            
            // 只添加有匹配分数的穴位
            if score > 0 {
                acupointScores.append((name: acupoint.name, score: score))
            }
        }
        
        // 按分数排序并返回所有匹配的穴位（分数大于0的）
        return acupointScores
            .filter { $0.score > 0 }
            .sorted { $0.score > $1.score }
            .map { $0.name }
    }
    
}
