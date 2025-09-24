import SwiftUI

struct WelcomeView: View {
    @State private var showMainApp = false
    
    var body: some View {
        NavigationStack {
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
                
                ScrollView {
                    VStack(spacing: 30) {
                        // 项目标题和描述
                        VStack(spacing: 16) {
                            Image(systemName: "heart.text.square.fill")
                                .font(.system(size: 60))
                                .foregroundColor(Color(hex: "68773F"))
                            
                            Text("Welcome to PressCare+")
                                .font(.system(.title, design: .serif))
                                .foregroundColor(Color(hex: "68773F"))
                            
                            Text("Your Smart Health Assistant")
                                .font(.system(.title2, design: .serif))
                                .foregroundColor(.secondary)
                            
                            Text("Discover the power of traditional Chinese medicine through this acupoint guide. Track and apply acupressure techniques for better health and wellness.")
                                .font(.system(.body, design: .serif))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))

                        NavigationLink(destination: ContentView()) {
                            Text("Start My Journey!")
                                .font(.system(.headline, design: .serif))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        colors: [
                                            Color(hex: "68773F"),
                                            Color(hex: "859650")
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .shadow(color: Color(hex: "68773F").opacity(0.3), radius: 5, x: 0, y: 2)
                        }
                        .padding(.horizontal)
                        // Why I Create PressCare+ Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("· Why I Create PressCare+")
                                .font(.system(.title, design: .serif))
                                .foregroundColor(Color(hex: "68773F"))
                                .padding(.bottom, 5)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Since my mother is a natural therapist in Traditional Chinese Medicine (TCM), she always wants to explain the principles of natural TCM treatments to her patients during treatment. This way, patients can treat themselves at home or deal with some unexpected problems. In this environment, as a high school student who loves programming, I came up with the idea of using a Swift mobile app to help my mother promote TCM natural therapies. I also hope to combine some new technologies to make this traditional TCM discipline more intelligent. After completing the program, my mother can promote it to her customers, and I can also enable more people from different countries and regions to understand TCM. With the help of Apple's mobile app platform, which is accessible to everyone, people can use TCM to solve some minor discomforts and alleviate some problems in their lives.")
                                    .font(.system(.body, design: .serif))
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                                
                                Text("Reason I choose acupuncture point pressing therapy")
                                    .font(.system(.headline, design: .serif))
                                    .foregroundColor(Color(hex: "68773F"))
                                    .padding(.top, 16)
                                
                                Text("The natural acupuncture point pressing therapy in traditional Chinese medicine can effectively help us relieve some symptoms, such as anxiety, insomnia, headaches, etc. Users can utilize this app to learn the location of the acupuncture points and get intelligent recommendations based on their symptoms to press the acupuncture points and alleviate their discomfort.")
                                    .font(.system(.body, design: .serif))
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                        // Features Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("· Features")
                                .font(.system(.title, design: .serif))
                                .foregroundColor(Color(hex: "68773F"))
                                .padding(.bottom, 5)
                            
                            // Feature 1
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Comprehensive Acupoint Database")
                                    .font(.system(.headline, design: .serif))
                                    .foregroundColor(Color(hex: "68773F"))
                                Text("I have created an acupuncture point database containing 77 commonly used natural treatment Chinese medicine acupuncture points, each corresponding to different meridians and effects. By classifying the location of the acupuncture points, a more distinctive search effect has been achieved. Users can also easily mark the acupuncture points they often press and save them to the Tracking Centre for easy viewing next time.")
                                    .font(.system(.body, design: .serif))
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            // Feature 2
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Smart Symptom Analysis")
                                    .font(.system(.headline, design: .serif))
                                    .foregroundColor(Color(hex: "68773F"))
                                Text("By using a weighted dictionary fuzzy search component, I have created a function for users to add their own symptoms. After adding symptoms, the application will conduct a weighted search for effects in the database and display the recommended acupuncture points to precisely address the body's needs. The system also has some common symptoms built-in. After selecting a symptom, users can choose the severity of the symptom, which helps professional doctors make further diagnoses and allows users to intuitively track and record their current perceived symptoms.")
                                    .font(.system(.body, design: .serif))
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            
                            // Feature 3
                            VStack(alignment: .leading, spacing: 8) {
                                Text("AR Body Acupoints Tracking")
                                    .font(.system(.headline, design: .serif))
                                    .foregroundColor(Color(hex: "68773F"))
                                Text("Also, I have designed an ARKit based human body recognition component. When users click the Track button at the bottom, the component will activate the Tracking-On mode, identify the outline of the human body, and automatically mark the acupuncture points on the body, making it easier for users to find the exact location of the acupuncture points. It can also track the location of acupuncture points on the body when turning around and adapt to different postures (users are required to keep their arms down to get the best tracking experience).")
                                    .font(.system(.body, design: .serif))
                                    .foregroundColor(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        

                        
                        
                        // What is TCM Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("· Traditional Chinese Medicine")
                                .font(.system(.title, design: .serif))
                                .foregroundColor(Color(hex: "68773F"))
                                .padding(.bottom, 5)
                            
                            Text("Traditional Chinese medicine (TCM) is based on the theoretical foundation of Yin-Yang and the Five Elements. It views the human body as a unity of Qi, form, and spirit. Through the comprehensive use of the four diagnostic methods - inspection, auscultation and olfaction, inquiry, and palpation - it seeks to identify the cause, nature, and location of diseases. It analyzes the changes in the body's organs, meridians, joints, Qi, blood, and body fluids, determines the balance between pathogenic factors and healthy Qi, and then derives the disease name and summarizes the syndrome type. Following the principle of syndrome differentiation and treatment, it formulates therapeutic methods such as \"sweating, vomiting, purging, harmonizing, warming, clearing, tonifying, and resolving\". It uses a variety of treatment methods including Chinese herbs, acupuncture, massage, cupping, Qigong, and dietary therapy to achieve the harmony of Yin and Yang in the body and promote recovery.")
                                .font(.system(.body, design: .serif))
                                .foregroundColor(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(24)
                        .frame(maxWidth: .infinity)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        
                    }
                    .padding()
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
