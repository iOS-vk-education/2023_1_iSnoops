//
//  SceneDelegate.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.10.2023.
//
// swiftlint:disable all
import UIKit
import FirebaseAuth

protocol switchAndFindButtonDelegate: AnyObject {
    func switchAndFindButton(theme: String)
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    weak var delegate: switchAndFindButtonDelegate?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        let window = UIWindow(windowScene: windowScene)
        self.window = window
//        window.rootViewController = TabBarController()
        
        self.window?.makeKeyAndVisible()
        
        if let theme = UserDefaults.standard.string(forKey: "selectedTheme"){
            switchTheme(delegate: ChoosingThemeView(), theme: theme)
        }
//        window?.rootViewController = UINavigationController(rootViewController: RegistrationViewController())
        self.checkAuthentication()
//        if !UserDefaults.standard.bool(forKey: "onboardingCompleted") {
//            window?.rootViewController = OnboardingViewController()
//        } else {
//            window?.rootViewController = UINavigationController(rootViewController: RegistrationViewController())
//
//        }
        
    }
    private func switchTheme(delegate: switchAndFindButtonDelegate, theme: String) {
        delegate.switchAndFindButton(theme: theme)
    }
    
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            print(Auth.auth().currentUser?.uid)
            self.goToController(with: UINavigationController(rootViewController: RegistrationViewController()))
        } else {
            print(Auth.auth().currentUser?.uid)
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
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
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
// swiftlint:enable all
