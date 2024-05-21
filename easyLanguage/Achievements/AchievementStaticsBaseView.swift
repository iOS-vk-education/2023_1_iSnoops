//
//  AchievementStaticsBaseView.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 15.04.2024.
//

import Foundation
import SwiftUI

struct AchievementStaticsBaseView: View {

    private enum Constants {
        static let imageSize: CGFloat = 115
        static let buttonsDistance: CGFloat = 10
        static let viewPaddingTop: CGFloat = 5
        static let viewPaddingBottom: CGFloat = 10
    }

    @State private var isAchievementViewActive = true
    @State var profile: ProfileApiModel?

    var body: some View {
        NavigationStack {
            ScrollViewReader { scroll in
                ScrollView {
                    VStack {
                        HStack {
                            Spacer()
                        }
                        AsyncImage(url: URL(string: profile?.imageLink ?? " ")) { image in
                            image.resizable()
                                .clipShape(Circle())
                        } placeholder: {
                            SwiftUI.ProgressView()
                        }
                        .frame(width: Constants.imageSize, height: Constants.imageSize)
                        Text(profile?.name ?? NSLocalizedString("nameLabel", comment: ""))
                            .bold()
                            .font(.title2)
                        HStack {
                            Button(NSLocalizedString("achievementButton", comment: "")) {
                                isAchievementViewActive = true
                            }
                            .font(.title3)
                            .foregroundStyle(
                                isAchievementViewActive ? .blue : .gray)
                            .padding(.trailing, Constants.buttonsDistance)
                            Button(NSLocalizedString("statisticsButton", comment: "")) {
                                isAchievementViewActive = false
                            }
                            .font(.title3)
                            .foregroundStyle(isAchievementViewActive ? .gray: .blue)
                        }
                        .padding(.top, Constants.viewPaddingTop)
                        .padding(.bottom, Constants.viewPaddingBottom)
                        Spacer()
                        if isAchievementViewActive {
                            AchievementView()
                        } else {
                            StatisticView()
                        }
                    }
                    .backgroundStyle(SwiftUI.Color(UIColor.PrimaryColors.Background.background))
                }
            }
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
        }.navigationTitle(NSLocalizedString("achievementStaticsTitle", comment: ""))
    }
}

#Preview {
    AchievementStaticsBaseView()
}
