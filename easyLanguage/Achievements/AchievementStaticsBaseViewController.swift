//
//  Achievement:StaticsBaseViewController.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 15.04.2024.
//

import Foundation
import SwiftUI


struct AchievementStaticsBaseViewController: View {
    @State private var achievementToggle = true
    @State private var isUIKitScreenPresented = false
    @State var profile: ProfileApiModel?
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                }
                .frame(height: 0)
                AsyncImage(url: URL(string: profile?.imageLink ?? " ")) { image in
                    image.resizable()
                        .clipShape(Circle())
                } placeholder: {
                    SwiftUI.ProgressView()
                }
                .frame(width: 115, height: 115)
                Text(profile?.name ?? "Имя").bold()
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
        }
        .onAppear {
            Task {
                do {
                    let profile = try await ProfileService.shared.loadProfile()
                    self.profile = profile
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .navigationTitle("Достижения")
    }
}

#Preview {
    AchievementStaticsBaseViewController()
}
