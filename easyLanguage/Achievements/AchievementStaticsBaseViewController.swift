//
//  Achievement:StaticsBaseViewController.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 15.04.2024.
//

import Foundation
import SwiftUI

struct UIKitViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let vc = ProfileViewController(
            themeViewOutput: ChoosingThemeView(),
            userInformationViewOutput: UserInformationView()
                                )
        return vc
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // Можете оставить пустым
    }
}

struct AchievementStaticsBaseViewController: View {
    @State private var achievementToggle = true
    @State private var isUIKitScreenPresented = false
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                            Button(action: {
                                isUIKitScreenPresented = true
                            }) {
                                    Image(systemName: "gearshape.fill")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 23))
                                    .padding(.trailing, 10)
                            }
                            NavigationLink(destination: UIKitViewController(), isActive: $isUIKitScreenPresented) {
                                                EmptyView()
                                            }
                    }
                }
                .frame(height: 0)
                Image(systemName: "sun.max.circle.fill")
                    .font(.system(size: 90))
                    .foregroundStyle(.cyan)
                    .padding(.bottom, 5)
                                   
                Text("Арсений").bold()
                    .font(.title2)
                HStack {
                    Button("Достижения") {
                        achievementToggle = true
                    }
                    .font(.title3)
                    .foregroundStyle(
                        achievementToggle ? .blue : .gray)
                    .padding(.trailing, 10)
                    Button("Статистика") {
                        achievementToggle = false
                    }
                    .font(.title3)
                    .foregroundStyle(achievementToggle ? .gray: .blue)
                }
                .padding(.top, 5)
                .padding(.bottom, 10)
                Spacer()
                if achievementToggle {
                    AchievementView()
                } else {
                    // TODO: View Матвея
                }
            }
                .background(SwiftUI.Color(UIColor.PrimaryColors.Background.background))
//            .padding()
        }
    }
}

#Preview {
    AchievementStaticsBaseViewController()
}
