import Foundation
import SwiftUI

// Define body regions
enum BodyRegion: String, CaseIterable {
    case head = "Head"
    case neck = "Neck"
    case chest = "Chest"
    case back = "Back"
    case arms = "Arms"
    case hands = "Hands"
    case legs = "Legs"
    case feet = "Feet"
}

// Define the structure for an acupoint
struct Acupoint: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let chineseName: String
    let description: String
    let bodyRegion: BodyRegion
    let benefits: [String]
    let location: String
    let coordinates: SIMD3<Float>? // 3D coordinates for AR placement
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Acupoint, rhs: Acupoint) -> Bool {
        lhs.id == rhs.id
    }
}

extension Acupoint {
    static let additionalAcupoints = [
        // Foot acupoints
        Acupoint(
            name: "KI1",
            chineseName: "Yong Quan 涌泉",
            description: "Located at the bottom of the foot, at the 1/3 point below the toes",
            bodyRegion: .feet,
            benefits: ["Nourish Yin and Kidney", "Calm Spirit", "Regulate Nervous System"],
            location: "Bottom of foot, at 1/3 point below toes, in the depression anterior to the junction of second and third metatarsal bones",
            coordinates: SIMD3<Float>(x: 0.1, y: 0.02, z: 0.0)
        ),
        Acupoint(
            name: "KI6",
            chineseName: "Zhao Hai 照海",
            description: "Located behind the medial malleolus, 1 cun below the Achilles tendon",
            bodyRegion: .feet,
            benefits: ["Tonify Kidney", "Nourish Yin"],
            location: "Behind medial malleolus, 1 cun below Achilles tendon",
            coordinates: SIMD3<Float>(x: 0.17, y: 0.07, z: 0.03)
        ),
        Acupoint(
            name: "KI2",
            chineseName: "Ran Gu 然谷",
            description: "Located on the medial side of the foot, above the Achilles tendon",
            bodyRegion: .feet,
            benefits: ["Strengthen Lower Back and Kidney", "Relieve Stress"],
            location: "Medial side of foot, above Achilles tendon",
            coordinates: SIMD3<Float>(x: 0.12, y: 0.03, z: 0.02)
        ),
        Acupoint(
            name: "KI3",
            chineseName: "Tai Xi 太溪",
            description: "Located above the medial malleolus, behind the ankle joint",
            bodyRegion: .feet,
            benefits: ["Nourish Yin and Kidney", "Regulate Endocrine", "Warm Yang"],
            location: "Above medial malleolus, behind ankle joint",
            coordinates: SIMD3<Float>(x: 0.15, y: 0.05, z: 0.03)
        ),
        Acupoint(
            name: "KI4",
            chineseName: "Da Zhong 大钟",
            description: "Located above the medial malleolus, on the anterior tibial crest",
            bodyRegion: .feet,
            benefits: ["Regulate Kidney Qi", "Relieve Weakness", "Balance Qi and Blood"],
            location: "Above medial malleolus, anterior tibial crest",
            coordinates: SIMD3<Float>(x: 0.16, y: 0.06, z: 0.03)
        ),
        // Facial acupoints
        Acupoint(
            name: "ST1",
            chineseName: "Cheng Qi 承泣",
            description: "Located below the orbital rim, 1 cun below the pupil",
            bodyRegion: .head,
            benefits: ["Clear Heat and Toxins", "Calm Spirit"],
            location: "Below orbital rim, 1 cun below pupil",
            coordinates: SIMD3<Float>(x: 0.2, y: 0.9, z: 0.1)
        ),
        Acupoint(
            name: "ST2",
            chineseName: "Si Bai 四白",
            description: "Located below the orbital rim, 1 cun below the pupil",
            bodyRegion: .head,
            benefits: ["Relieve Eye Fatigue", "Clear Liver and Brighten Eyes"],
            location: "Below orbital rim, 1 cun below pupil",
            coordinates: SIMD3<Float>(x: 0.21, y: 0.89, z: 0.1)
        ),
        Acupoint(
            name: "ST3",
            chineseName: "Ju Liao 巨髎",
            description: "Located on the face, beside the nasal wing",
            bodyRegion: .head,
            benefits: ["Reduce Swelling", "Clear Heat"],
            location: "On the face, beside the nasal wing",
            coordinates: SIMD3<Float>(x: 0.22, y: 0.88, z: 0.12)
        ),
        // Head acupoints
        Acupoint(
            name: "GB14",
            chineseName: "Tou Wei 头维",
            description: "Located above the forehead, at the center of the forehead",
            bodyRegion: .head,
            benefits: ["Relieve Headache", "Clear Heat and Toxins"],
            location: "Above forehead, at the center of the forehead",
            coordinates: SIMD3<Float>(x: 0.25, y: 0.95, z: 0.1)
        ),
        // Neck acupoints
        Acupoint(
            name: "ST9",
            chineseName: "Ren Ying 人迎",
            description: "Located in the neck, 1 cun above the Adam's apple",
            bodyRegion: .neck,
            benefits: ["Regulate Qi and Blood", "Clear Heat and Toxins"],
            location: "Neck, 1 cun above Adam's apple",
            coordinates: SIMD3<Float>(x: 0.3, y: 0.85, z: 0.08)
        ),
        // Ear acupoints
        Acupoint(
            name: "GB2",
            chineseName: "Ting Hui 听会",
            description: "Located below the ear",
            bodyRegion: .head,
            benefits: ["Clear Ear Channels", "Relieve Tinnitus"],
            location: "Below the ear",
            coordinates: SIMD3<Float>(x: 0.18, y: 0.92, z: 0.15)
        ),
        Acupoint(
            name: "PC3",
            chineseName: "Qu Ze 曲泽",
            description: "Located at the front of the elbow, at the intersection of the biceps tendon and the elbow",
            bodyRegion: .arms,
            benefits: ["Clear Meridians", "Relieve Chest Tension"],
            location: "Front of elbow, at the intersection of biceps tendon and elbow",
            coordinates: SIMD3<Float>(x: 0.35, y: 0.6, z: 0.15)
        ),
        Acupoint(
            name: "LI11",
            chineseName: "Shang Lian 上廉",
            description: "Located on the lateral elbow, near the wrist",
            bodyRegion: .arms,
            benefits: ["Clear Meridians", "Relieve Pain"],
            location: "Lateral elbow, near wrist",
            coordinates: SIMD3<Float>(x: 0.32, y: 0.58, z: 0.15)
        ),
        Acupoint(
            name: "LI10",
            chineseName: "Shou San Li 手三里",
            description: "Located on the lateral side of the arm, 3 cun below the elbow",
            bodyRegion: .arms,
            benefits: ["Regulate Qi", "Clear Meridians"],
            location: "3 cun below elbow, lateral side of arm",
            coordinates: SIMD3<Float>(x: 0.30, y: 0.55, z: 0.15)
        ),
        Acupoint(
            name: "LI1",
            chineseName: "Guan Chong 关冲",
            description: "Located at the tip of the index finger",
            bodyRegion: .hands,
            benefits: ["Regulate Qi and Blood", "Clear Meridians"],
            location: "Index finger tip",
            coordinates: SIMD3<Float>(x: 0.10, y: 0.15, z: 0.15)
        ),
        Acupoint(
            name: "PC6",
            chineseName: "Nei Guan 内关",
            description: "Located on the inner forearm, two finger-widths above the wrist crease",
            bodyRegion: .arms,
            benefits: ["Clear Pericardium Meridian", "Relieve Palpitations"],
            location: "Inner forearm, two finger-widths above wrist crease",
            coordinates: SIMD3<Float>(x: 0.28, y: 0.45, z: 0.15)
        ),
        Acupoint(
            name: "CV17",
            chineseName: "Xin Xiong 心胸",
            description: "Located in the upper chest, 1 cun lateral to the sternum",
            bodyRegion: .chest,
            benefits: ["Clear Chest Stagnation", "Regulate Breathing"],
            location: "Upper chest, 1 cun lateral to sternum",
            coordinates: SIMD3<Float>(x: 0.25, y: 0.85, z: 0.1)
        ),
        Acupoint(
            name: "PC8",
            chineseName: "Lao Gong 劳宫",
            description: "Located at the center of the palm",
            bodyRegion: .hands,
            benefits: ["Calm Spirit", "Regulate Emotions"],
            location: "Center of palm",
            coordinates: SIMD3<Float>(x: 0.15, y: 0.2, z: 0.15)
        ),
        Acupoint(
            name: "PC7",
            chineseName: "Da Ling 大陵",
            description: "Located below the wrist crease, on the palm side",
            bodyRegion: .hands,
            benefits: ["Soothe Heart", "Calm Spirit"],
            location: "Below wrist crease, palm side",
            coordinates: SIMD3<Float>(x: 0.18, y: 0.25, z: 0.15)
        ),
        Acupoint(
            name: "CV14",
            chineseName: "Tian Xin 天心",
            description: "Located in the upper middle chest, 2 cun above the navel",
            bodyRegion: .chest,
            benefits: ["Nourish Heart", "Regulate Heart Qi"],
            location: "Upper middle chest, 2 cun above navel",
            coordinates: SIMD3<Float>(x: 0.22, y: 0.82, z: 0.1)
        ),
        Acupoint(
            name: "SI13",
            chineseName: "Tian Quan 天泉",
            description: "Located behind the shoulder, below the scapula",
            bodyRegion: .back,
            benefits: ["Regulate Triple Burner", "Relieve Shoulder Tension"],
            location: "Behind shoulder, below scapula",
            coordinates: SIMD3<Float>(x: 0.35, y: 0.9, z: -0.1)
        ),
        Acupoint(
            name: "GB21",
            chineseName: "Jian Jiao 肩髎",
            description: "Located above the shoulder, between the acromion and the neck",
            bodyRegion: .neck,
            benefits: ["Relieve Shoulder Pressure", "Activate Meridians"],
            location: "Above shoulder, between acromion and neck",
            coordinates: SIMD3<Float>(x: 0.4, y: 0.95, z: 0.05)
        ),
        Acupoint(
            name: "SI17",
            chineseName: "Tian Ding 天鼎",
            description: "Located behind the ear, an extension of the neck",
            bodyRegion: .neck,
            benefits: ["Clear Triple Burner", "Relieve Neck and Shoulder Tension"],
            location: "Behind ear, extension of neck",
            coordinates: SIMD3<Float>(x: 0.15, y: 1.0, z: 0.0)
        ),
        Acupoint(
            name: "SJ3",
            chineseName: "Zhong Zhu 中渚",
            description: "Located on the back of the hand, on the palm side",
            bodyRegion: .hands,
            benefits: ["Clear Heat", "Regulate Qi"],
            location: "Back of hand, palm side",
            coordinates: SIMD3<Float>(x: 0.12, y: 0.18, z: 0.15)
        ),
        Acupoint(
            name: "SJ4",
            chineseName: "Yang Chi 阳池",
            description: "Located at the wrist, on the palm side",
            bodyRegion: .hands,
            benefits: ["Regulate Qi and Blood", "Clear Heat"],
            location: "Wrist, palm side",
            coordinates: SIMD3<Float>(x: 0.14, y: 0.20, z: 0.15)
        ),
        Acupoint(
            name: "SJ5",
            chineseName: "Zhi Gou 支沟",
            description: "Located on the forearm, 2 cun above the wrist",
            bodyRegion: .arms,
            benefits: ["Clear Meridians", "Reduce Heat", "Regulate Triple Burner", "Relieve Body Fatigue"],
            location: "Forearm, 2 cun above wrist",
            coordinates: SIMD3<Float>(x: 0.28, y: 0.42, z: 0.18)
        ),
        Acupoint(
            name: "SJ6",
            chineseName: "Hui Jing 会宗",
            description: "Located on the forearm, near the Zhigou point",
            bodyRegion: .arms,
            benefits: ["Clear Meridians", "Reduce Heat"],
            location: "Forearm, near Zhigou point",
            coordinates: SIMD3<Float>(x: 0.29, y: 0.44, z: 0.18)
        ),
        Acupoint(
            name: "SJ7",
            chineseName: "San Yang Luo 三阳络",
            description: "Located on the forearm, near the Huizong point",
            bodyRegion: .arms,
            benefits: ["Clear Meridians", "Promote Qi and Blood Circulation"],
            location: "Forearm, near Huizong point",
            coordinates: SIMD3<Float>(x: 0.3, y: 0.46, z: 0.18)
        ),
        Acupoint(
            name: "SJ9",
            chineseName: "Si Du 四渎",
            description: "Located on the forearm, near the Sanyangluo point",
            bodyRegion: .arms,
            benefits: ["Clear Meridians", "Activate Blood"],
            location: "Forearm, near Sanyangluo point",
            coordinates: SIMD3<Float>(x: 0.31, y: 0.48, z: 0.18)
        ),
        Acupoint(
            name: "SJ10",
            chineseName: "Tian Jing 天井",
            description: "Located on the lateral elbow, above the olecranon",
            bodyRegion: .arms,
            benefits: ["Clear Meridians", "Reduce Heat"],
            location: "Lateral elbow, above olecranon",
            coordinates: SIMD3<Float>(x: 0.33, y: 0.55, z: 0.2)
        ),
        // Lung meridian acupoints
        Acupoint(
            name: "LU1",
            chineseName: "Zhong Fu 中府",
            description: "Located below the clavicle, 6 cun lateral to the sternum",
            bodyRegion: .chest,
            benefits: ["Disperse Lung Qi", "Stop Cough and Relieve Asthma"],
            location: "Below clavicle, 6 cun lateral to sternum",
            coordinates: SIMD3<Float>(x: 0.3, y: 0.75, z: 0.1)
        ),
        Acupoint(
            name: "LU2",
            chineseName: "Yun Men 云门",
            description: "Located in the chest, 2 cun below the clavicle",
            bodyRegion: .chest,
            benefits: ["Disperse Lung Qi", "Regulate Qi", "Reduce Fire"],
            location: "Chest, 2 cun below clavicle",
            coordinates: SIMD3<Float>(x: 0.28, y: 0.78, z: 0.1)
        ),
        Acupoint(
            name: "LU3",
            chineseName: "Tian Fu 天府",
            description: "Located above the shoulder, below the clavicle, 3 cun lateral to the sternum",
            bodyRegion: .chest,
            benefits: ["Harmonize Lung Qi", "Benefit Cough", "Calm Breathing"],
            location: "Above shoulder, below clavicle, 3 cun lateral to sternum",
            coordinates: SIMD3<Float>(x: 0.29, y: 0.77, z: 0.1)
        ),
        Acupoint(
            name: "LU4",
            chineseName: "Xi Bai 侠白",
            description: "Located in the chest, 5 cun lateral to the sternum below the clavicle",
            bodyRegion: .chest,
            benefits: ["Promote Lung Qi", "Clear the airways"],
            location: "Chest, 5 cun lateral to the sternum below the clavicle",
            coordinates: SIMD3<Float>(x: 0.31, y: 0.76, z: 0.1)
        ),
        Acupoint(
            name: "LU5",
            chineseName: "Chi Ze 尺泽",
            description: "Located on the medial side of the humerus, between the elbow and the shoulder",
            bodyRegion: .arms,
            benefits: ["Promote Lung Qi", "Benefit Qi", "Stop cough"],
            location: "Medial side of the humerus, between the elbow and the shoulder",
            coordinates: SIMD3<Float>(x: 0.34, y: 0.57, z: 0.15)
        ),
        Acupoint(
            name: "LU6",
            chineseName: "Kong Zui 孔最",
            description: "Located on the forearm, 1 cun above the biceps tendon",
            bodyRegion: .arms,
            benefits: ["Clear Lung and Stop Cough", "Benefit cough"],
            location: "Forearm, 1 cun above the biceps tendon",
            coordinates: SIMD3<Float>(x: 0.33, y: 0.54, z: 0.15)
        ),
        Acupoint(
            name: "LU7",
            chineseName: "Lie Que 列缺",
            description: "Located on the forearm, between the lower end of the humerus and the elbow joint",
            bodyRegion: .arms,
            benefits: ["Promote Lung Qi", "Benefit Qi", "Clear Heat"],
            location: "Forearm, between the lower end of the humerus and the elbow joint",
            coordinates: SIMD3<Float>(x: 0.31, y: 0.5, z: 0.15)
        ),
        Acupoint(
            name: "LU8",
            chineseName: "Jing Qu 经渠",
            description: "Located on the back of the wrist, 1 cun from the wrist on the midline",
            bodyRegion: .hands,
            benefits: ["Clear Lung", "Smooth the airways"],
            location: "Back of the wrist, 1 cun from the wrist on the midline",
            coordinates: SIMD3<Float>(x: 0.2, y: 0.3, z: 0.15)
        ),
        Acupoint(
            name: "LU9",
            chineseName: "Tai Yuan 太渊",
            description: "Located at the wrist, 1 cun below the radial styloid process",
            bodyRegion: .hands,
            benefits: ["Clear Lung and Tonify Kidney", "Calm Spirit and Stabilize Will"],
            location: "Wrist, 1 cun below the radial styloid process",
            coordinates: SIMD3<Float>(x: 0.19, y: 0.28, z: 0.15)
        ),
        Acupoint(
            name: "LU10",
            chineseName: "Yu Jie 鱼际",
            description: "Located on the back of the palm, at the junction between the thumb and index finger",
            bodyRegion: .hands,
            benefits: ["Regulate Lung Qi", "Detoxify"],
            location: "Back of the palm, at the junction between the thumb and index finger",
            coordinates: SIMD3<Float>(x: 0.17, y: 0.25, z: 0.15)
        ),
        Acupoint(
            name: "LU11",
            chineseName: "Shao Shang 少商",
            description: "Located at the tip of the index finger",
            bodyRegion: .hands,
            benefits: ["Clear Lung", "Benefit Qi"],
            location: "Tip of the index finger",
            coordinates: SIMD3<Float>(x: 0.15, y: 0.22, z: 0.15)
        ),
        // Pericardium meridian acupoints
        Acupoint(
            name: "PC1",
            chineseName: "Tian Chi 天池",
            description: "Located in the chest, at the center of the armpit",
            bodyRegion: .chest,
            benefits: ["Calm Spirit", "Relieve Chest Distress"],
            location: "Chest, at the center of the armpit",
            coordinates: SIMD3<Float>(x: 0.27, y: 0.8, z: 0.1)
        ),
        Acupoint(
            name: "PC2",
            chineseName: "Tian Quan 天泉",
            description: "Located in the elbow, in the middle of the armpit",
            bodyRegion: .arms,
            benefits: ["Smooth the meridians", "Calm Spirit and Stabilize Will"],
            location: "Elbow, in the middle of the armpit",
            coordinates: SIMD3<Float>(x: 0.32, y: 0.6, z: 0.15)
        ),
        Acupoint(
            name: "PC3",
            chineseName: "Qu Ze 曲泽",
            description: "Located on the medial side of the elbow, 1 cun above the humerus",
            bodyRegion: .arms,
            benefits: ["Clear Heat and Detoxify", "Smooth the meridians"],
            location: "Medial side of the elbow, 1 cun above the humerus",
            coordinates: SIMD3<Float>(x: 0.31, y: 0.58, z: 0.15)
        ),
        Acupoint(
            name: "PC4",
            chineseName: "Xi Men 郄门",
            description: "Located on the medial side of the elbow, 1 cun below the humerus",
            bodyRegion: .arms,
            benefits: ["Calm the Heart and Spirit", "Smooth the meridians"],
            location: "Medial side of the elbow, 1 cun below the humerus",
            coordinates: SIMD3<Float>(x: 0.3, y: 0.56, z: 0.15)
        ),
        Acupoint(
            name: "PC5",
            chineseName: "Jian Shi 间使",
            description: "Located on the forearm, 3 cun above the wrist from the lower edge of the elbow",
            bodyRegion: .arms,
            benefits: ["Regulate Qi", "Calm Spirit and Stabilize Will"],
            location: "Forearm, 3 cun above the wrist from the lower edge of the elbow",
            coordinates: SIMD3<Float>(x: 0.29, y: 0.52, z: 0.15)
        ),
        Acupoint(
            name: "PC6",
            chineseName: "Nei Guan 内关",
            description: "Located on the medial side of the forearm, 3 cun from the midpoint of the wrist",
            bodyRegion: .arms,
            benefits: ["Regulate Qi", "Calm Spirit", "Soothe the Heart"],
            location: "Medial side of the forearm, 3 cun from the midpoint of the wrist",
            coordinates: SIMD3<Float>(x: 0.28, y: 0.48, z: 0.15)
        ),
        Acupoint(
            name: "PC7",
            chineseName: "Da Ling 大陵",
            description: "Located on the wrist, on the palm side",
            bodyRegion: .hands,
            benefits: ["Clear Heart and Remove Irritability", "Sedative"],
            location: "Wrist, on the palm side",
            coordinates: SIMD3<Float>(x: 0.25, y: 0.35, z: 0.15)
        ),
        Acupoint(
            name: "PC8",
            chineseName: "Lao Gong 劳宫",
            description: "Located in the center of the palm, at the third metacarpophalangeal joint",
            bodyRegion: .hands,
            benefits: ["Calm the Heart and Spirit", "Soothe the Heart and Stabilize Will"],
            location: "Center of the palm, at the third metacarpophalangeal joint",
            coordinates: SIMD3<Float>(x: 0.22, y: 0.32, z: 0.15)
        ),
        Acupoint(
            name: "PC9",
            chineseName: "Zhong Chong 中冲",
            description: "Located at the center of the fingertip",
            bodyRegion: .hands,
            benefits: ["Clear Heat and Detoxify", "Revitalize"],
            location: "Center of the fingertip",
            coordinates: SIMD3<Float>(x: 0.2, y: 0.3, z: 0.15)
        ),
        // Heart meridian acupoints
        Acupoint(
            name: "HT1",
            chineseName: "Ji Quan 极泉",
            description: "Located in the armpit, at the center of the armpit",
            bodyRegion: .chest,
            benefits: ["Tonify Heart Qi", "Calm Spirit"],
            location: "Armpit, at the center of the armpit",
            coordinates: SIMD3<Float>(x: 0.35, y: 0.7, z: 0.15)
        ),
        Acupoint(
            name: "HT2",
            chineseName: "Qing Ling 青灵",
            description: "Located in the chest, at the second intercostal space below the armpit",
            bodyRegion: .chest,
            benefits: ["Clear Heart Fire", "Calm Spirit"],
            location: "Chest, at the second intercostal space below the armpit",
            coordinates: SIMD3<Float>(x: 0.34, y: 0.68, z: 0.15)
        ),
        Acupoint(
            name: "HT3",
            chineseName: "Shao Hai 少海",
            description: "Located on the medial side of the elbow, at the elbow fossa",
            bodyRegion: .arms,
            benefits: ["Calm Spirit", "Clear Heart Fire"],
            location: "Medial side of the elbow, at the elbow fossa",
            coordinates: SIMD3<Float>(x: 0.33, y: 0.65, z: 0.15)
        ),
        Acupoint(
            name: "HT4",
            chineseName: "Ling Dao 灵道",
            description: "Located on the forearm, 3 cun below the elbow fossa",
            bodyRegion: .arms,
            benefits: ["Clear Heart Fire", "Regulate Qi and Smooth the Meridians"],
            location: "Forearm, 3 cun below the elbow fossa",
            coordinates: SIMD3<Float>(x: 0.32, y: 0.62, z: 0.15)
        ),
        Acupoint(
            name: "HT5",
            chineseName: "Tong Li 通里",
            description: "Located on the medial side of the forearm, 2 cun below the humerus",
            bodyRegion: .arms,
            benefits: ["Regulate Heart Qi", "Calm Spirit"],
            location: "Medial side of the forearm, 2 cun below the humerus",
            coordinates: SIMD3<Float>(x: 0.31, y: 0.59, z: 0.15)
        ),
        Acupoint(
            name: "HT6",
            chineseName: "Yin Xi 阴郄",
            description: "Located on the medial side of the forearm, 3 cun below the humerus",
            bodyRegion: .arms,
            benefits: ["Clear Heart and Detoxify", "Calm Spirit and Stabilize Will"],
            location: "Medial side of the forearm, 3 cun below the humerus",
            coordinates: SIMD3<Float>(x: 0.30, y: 0.56, z: 0.15)
        ),
        Acupoint(
            name: "HT7",
            chineseName: "Shen Men 神门",
            description: "Located on the wrist, 1 cun above the transverse wrist line on the ulnar side",
            bodyRegion: .hands,
            benefits: ["Calm Spirit", "Soothe the Heart", "Aid Sleep"],
            location: "Wrist, 1 cun above the transverse wrist line on the ulnar side",
            coordinates: SIMD3<Float>(x: 0.28, y: 0.45, z: 0.15)
        ),
        Acupoint(
            name: "HT8",
            chineseName: "Shao Fu 少府",
            description: "Located on the side of the palm, at the heart area",
            bodyRegion: .hands,
            benefits: ["Calm Spirit and Stabilize Will", "Smooth the Meridians"],
            location: "Side of the palm, at the heart area",
            coordinates: SIMD3<Float>(x: 0.26, y: 0.42, z: 0.15)
        ),
        Acupoint(
            name: "HT9",
            chineseName: "Shao Chong 少冲",
            description: "Located at the tip of the little finger",
            bodyRegion: .hands,
            benefits: ["Clear Heart Fire", "Calm Spirit"],
            location: "Tip of the little finger",
            coordinates: SIMD3<Float>(x: 0.24, y: 0.40, z: 0.15)
        ),
        // Large Intestine meridian acupoints
        Acupoint(
            name: "LI1",
            chineseName: "Shang Yang 商阳",
            description: "Located at the tip of the index finger, at the base of the nail",
            bodyRegion: .hands,
            benefits: ["Clear Heat", "Detoxify", "Benefit the throat"],
            location: "Tip of the index finger, at the base of the nail",
            coordinates: SIMD3<Float>(x: 0.22, y: 0.38, z: 0.15)
        ),
        Acupoint(
            name: "LI2",
            chineseName: "Er Jian 二间",
            description: "Located at the second joint of the index finger",
            bodyRegion: .hands,
            benefits: ["Smooth the airways", "Clear Heat and Detoxify"],
            location: "Second joint of the index finger",
            coordinates: SIMD3<Float>(x: 0.20, y: 0.36, z: 0.15)
        ),
        Acupoint(
            name: "LI3",
            chineseName: "San Jian 三间",
            description: "Located at the third joint of the index finger",
            bodyRegion: .hands,
            benefits: ["Clear Heat and Detoxify", "Smooth the blood and Qi"],
            location: "Third joint of the index finger",
            coordinates: SIMD3<Float>(x: 0.18, y: 0.34, z: 0.15)
        ),
        Acupoint(
            name: "LI4",
            chineseName: "He Gu 合谷",
            description: "Located on the back of the hand, at the intersection extended from the thumb and index finger",
            bodyRegion: .hands,
            benefits: ["Dispel wind and clear heat", "Relieve headache"],
            location: "Back of the hand, at the intersection extended from the thumb and index finger",
            coordinates: SIMD3<Float>(x: 0.16, y: 0.32, z: 0.15)
        ),
        Acupoint(
            name: "LI5",
            chineseName: "Yang Xi 阳溪",
            description: "Located on the wrist, on the palm side",
            bodyRegion: .hands,
            benefits: ["Benefit the throat", "Smooth the airways"],
            location: "Wrist, on the palm side",
            coordinates: SIMD3<Float>(x: 0.14, y: 0.30, z: 0.15)
        ),
        Acupoint(
            name: "LI6",
            chineseName: "Pian Li 偏历",
            description: "Located on the forearm, at the transverse line of the wrist",
            bodyRegion: .arms,
            benefits: ["Clear Heat and Detoxify", "Reduce swelling"],
            location: "Forearm, at the transverse line of the wrist",
            coordinates: SIMD3<Float>(x: 0.12, y: 0.28, z: 0.15)
        ),
        Acupoint(
            name: "LI7",
            chineseName: "Wen Liu 温溜",
            description: "Located on the forearm, near the humerus on the palm side",
            bodyRegion: .arms,
            benefits: ["Clear Lung Fire", "Stop cough"],
            location: "Forearm, near the humerus on the palm side",
            coordinates: SIMD3<Float>(x: 0.10, y: 0.26, z: 0.15)
        ),
        Acupoint(
            name: "LI8",
            chineseName: "Xia Lian 下廉",
            description: "Located on the lateral side of the upper arm, near the elbow",
            bodyRegion: .arms,
            benefits: ["Smooth the meridians", "Relieve pain"],
            location: "Lateral side of the upper arm, near the elbow",
            coordinates: SIMD3<Float>(x: 0.08, y: 0.24, z: 0.15)
        ),
        Acupoint(
            name: "SP1",
            chineseName: "Yin Bai 隐白",
            description: "Located at the root of the big toe, at the corner of the toenail",
            bodyRegion: .feet,
            benefits: ["Tonify Spleen", "Regulate Qi and Blood"],
            location: "Root of the big toe, at the corner of the toenail",
            coordinates: SIMD3<Float>(x: 0.1, y: 0.05, z: 0.05)
        ),
        Acupoint(
            name: "SP3",
            chineseName: "Tai Bai 太白",
            description: "Located on the inner side of the foot, below the ankle bone",
            bodyRegion: .feet,
            benefits: ["Tonify Spleen and Stomach", "Promote digestion"],
            location: "Inner side of the foot, below the ankle bone",
            coordinates: SIMD3<Float>(x: 0.15, y: 0.08, z: 0.05)
        ),
        Acupoint(
            name: "LR1",
            chineseName: "Da Dun 大敦",
            description: "Located at the tip of the big toe",
            bodyRegion: .feet,
            benefits: ["Clear Heat", "Smooth the meridians"],
            location: "Tip of the big toe",
            coordinates: SIMD3<Float>(x: 0.08, y: 0.02, z: 0.05)
        ),
        Acupoint(
            name: "LR3",
            chineseName: "Tai Chong 太冲",
            description: "Located between the big toe and the second toe",
            bodyRegion: .feet,
            benefits: ["Smooth the blood and Qi", "Activate Liver Qi"],
            location: "Between the big toe and the second toe",
            coordinates: SIMD3<Float>(x: 0.09, y: 0.03, z: 0.05)
        ),
        Acupoint(
            name: "SP4",
            chineseName: "Gong Sun 公孙",
            description: "Located on the inner side of the foot, at the front edge of the sole",
            bodyRegion: .feet,
            benefits: ["Regulate Spleen and Stomach", "Enhance digestive capacity"],
            location: "Inner side of the foot, at the front edge of the sole",
            coordinates: SIMD3<Float>(x: 0.12, y: 0.06, z: 0.05)
        ),
        Acupoint(
            name: "SP5",
            chineseName: "Shang Qiu 商丘",
            description: "Located on the inner side of the foot, 2 cun above the ankle",
            bodyRegion: .feet,
            benefits: ["Tonify Spleen and Stomach", "Regulate Spleen and Stomach"],
            location: "Inner side of the foot, 2 cun above the ankle",
            coordinates: SIMD3<Float>(x: 0.18, y: 0.1, z: 0.05)
        ),
        Acupoint(
            name: "SP6",
            chineseName: "San Yin Jiao 三阴交",
            description: "Located on the medial side of the leg, 4 cun above the patella",
            bodyRegion: .legs,
            benefits: ["Nourish Yin and Blood", "Regulate menstruation"],
            location: "Medial side of the leg, 4 cun above the patella",
            coordinates: SIMD3<Float>(x: 0.2, y: 0.3, z: 0.1)
        ),
        Acupoint(
            name: "SP9",
            chineseName: "Yin Ling Quan 阴陵泉",
            description: "Located on the medial side of the knee, 3 cun below the lower edge of the patella",
            bodyRegion: .legs,
            benefits: ["Regulate Spleen and Stomach", "Promote digestion and absorption"],
            location: "Medial side of the knee, 3 cun below the lower edge of the patella",
            coordinates: SIMD3<Float>(x: 0.22, y: 0.35, z: 0.1)
        ),
        Acupoint(
            name: "SP10",
            chineseName: "Xue Hai 血海",
            description: "Located on the medial side of the thigh, 4 cun above the upper edge of the patella",
            bodyRegion: .legs,
            benefits: ["Activate blood and resolve stasis", "Regulate menstruation"],
            location: "Medial side of the thigh, 4 cun above the upper edge of the patella",
            coordinates: SIMD3<Float>(x: 0.25, y: 0.4, z: 0.1)
        ),
        Acupoint(
            name: "SP11",
            chineseName: "Ji Men 箕门",
            description: "Located on the medial side of the thigh, 4 cun below the lower edge of the patella",
            bodyRegion: .legs,
            benefits: ["Promote blood circulation", "Enhance immunity"],
            location: "Medial side of the thigh, 4 cun below the lower edge of the patella",
            coordinates: SIMD3<Float>(x: 0.28, y: 0.45, z: 0.1)
        )
    ]
    static let allAcupoints = additionalAcupoints
}