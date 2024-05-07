//
//  SplashPresenter.swift
//  easyLanguage
//
//  Created by Grigoriy on 05.05.2024.
//

import UIKit

protocol ISplashPresenter {
    func present()
    func dismiss(completion: (() -> Void)?)
}

final class SplashPresenter: ISplashPresenter {

    private lazy var foregroundSplashWindow: UIWindow = {
        let window = UIWindow()
        window.windowLevel = .normal + 1
        window.rootViewController = SplashViewController()
        return window
    }()

    func present() {
        foregroundSplashWindow.isHidden = false
        let splashViewController = SplashViewController()

        UIView.animate(withDuration: 1.5, animations: {
            splashViewController.logo.transform = CGAffineTransform(scaleX: 10, y: 0)

        })
    }

    func dismiss(completion: (() -> Void)?) {
//        <#code#>
    }
}
