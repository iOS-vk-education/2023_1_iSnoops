//
//  SceneDelegate.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.10.2023.
//
// swiftlint:disable all
import UIKit
import FirebaseAuth
import SwiftUI

protocol switchAndFindButtonDelegate: AnyObject {
    func switchAndFindButton(theme: String)
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    weak var delegate: switchAndFindButtonDelegate?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        UNUserNotificationCenter.current().delegate = self

        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.makeKeyAndVisible()

        setupTheme()
        checkAuthentication()
    }

    func setupTheme() {
        if let theme = UserDefaults.standard.string(forKey: "selectedTheme") {
            switchTheme(delegate: ChoosingThemeView(), theme: theme)
        } else {
            UserDefaults.standard.set(NSLocalizedString("lightThemeLabel", comment: ""), forKey: "selectedTheme")
            switchTheme(delegate: ChoosingThemeView(), theme: NSLocalizedString("lightThemeLabel", comment: ""))
        }
    }

    private func switchTheme(delegate: switchAndFindButtonDelegate, theme: String) {
        delegate.switchAndFindButton(theme: theme)
    }

    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            self.goToController(with: UINavigationController(rootViewController: RegistrationViewController()))
        } else {
            self.goToController(with: TabBarController())
        }
    }

    private func goToController(with viewController: UIViewController) {
        let nav = viewController
        nav.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = nav
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0 // обнуление пушей при открытии прила
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

extension SceneDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.identifier == .isCompletedCreateFirstCategory {
            presentAchievements()
        }
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
}

// MARK: - push present

private extension SceneDelegate {
    private func presentAchievements() {
        let profileView = AchievementStaticsBaseView()
        let hostingController = UIHostingController(rootView: profileView)
        hostingController.modalPresentationStyle = .pageSheet

        if let rootViewController = window?.rootViewController {
            rootViewController.present(hostingController, animated: true, completion: nil)
        } else {
            window?.rootViewController = hostingController
            window?.makeKeyAndVisible()
        }
    }
}
// swiftlint:enable all
