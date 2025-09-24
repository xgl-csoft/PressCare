import Foundation

class LLMService {
    static let shared = LLMService()
    
    private init() {}
    
    // Data
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
        let allAcupoints = Acupoint.additionalAcupoints
        let keywords = symptoms.components(separatedBy: CharacterSet(charactersIn: ",.，。 "))
            .filter { !$0.isEmpty }
            .map { $0.lowercased() }
        var acupointScores: [(name: String, score: Int)] = []
        
        for acupoint in allAcupoints {
            var score = 0
            for keyword in keywords {
                if acupoint.name.localizedCaseInsensitiveContains(keyword) {
                    score += 3 
                }
                if acupoint.chineseName.localizedCaseInsensitiveContains(keyword) {
                    score += 3
                }
                
                if let relatedBenefits = symptomToBenefitMap[keyword] {
                    for benefit in acupoint.benefits {
                        let benefitLower = benefit.lowercased()
                        for relatedBenefit in relatedBenefits {
                            if benefitLower.contains(relatedBenefit.lowercased()) {
                                score += 4 
                                break
                            }
                        }
                    }
                }
                
                for benefit in acupoint.benefits {
                    if benefit.localizedCaseInsensitiveContains(keyword) {
                        score += 2 
                    }
                }
                
                // 检查描述是否匹配
                if acupoint.description.localizedCaseInsensitiveContains(keyword) {
                    score += 1 
                }
            }
            
            if score > 0 {
                acupointScores.append((name: acupoint.name, score: score))
            }
        }

        return acupointScores
            .filter { $0.score > 0 }
            .sorted { $0.score > $1.score }
            .map { $0.name }
    }
    
}
