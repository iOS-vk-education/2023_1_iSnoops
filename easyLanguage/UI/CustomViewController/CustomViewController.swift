//
//  CastomViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 05.11.2023.
//

import UIKit

class CustomViewController: UIViewController {
    private let loadingIndicatorView = LoadingIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(loadingIndicatorView)
        setVisualAppearance()
        setLoadView()
        startLoadActivity()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.stopLoadActivity()
        })
    }
}

// MARK: - open methods
extension CustomViewController {
    /// старт отображения индикатора загрузки
    func startLoadActivity() {
        loadingIndicatorView.startLoadActivity()
        loadingIndicatorView.isHidden = false
    }

    /// конец отображения индикатора загрузки
    func stopLoadActivity() {
        UIView.animate(
            withDuration: 0.5,
            delay: 0.7,
            animations: { [weak self] in
                self?.loadingIndicatorView.alpha = 0
            },
            completion: { [weak self] _ in
                self?.loadingIndicatorView.stopLoadActivity()
                self?.loadingIndicatorView.isHidden = true
            }
        )
    }
}

// MARK: - private methods
private extension CustomViewController {
    func setVisualAppearance() {
        loadingIndicatorView.isHidden = true
        view.backgroundColor = .PrimaryColors.Background.background
        loadingIndicatorView.layer.cornerRadius = Constants.LoadView.cornerRadius
        loadingIndicatorView.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
    }

    func setLoadView() {
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loadingIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingIndicatorView.heightAnchor.constraint(equalToConstant:
                                                        UIConstants.LoadingIndicatorView.height).isActive = true
        loadingIndicatorView.widthAnchor.constraint(equalToConstant:
                                                        UIConstants.LoadingIndicatorView.width).isActive = true
    }
}

// MARK: - Constants
// swiftlint:disable nesting
extension CustomViewController {
    struct Constants {
        struct LoadView {
            static let cornerRadius: CGFloat = 12
        }
    }
    struct UIConstants {
        struct LoadingIndicatorView {
            static let height: CGFloat = 70
            static let width: CGFloat = 110
        }
    }
}
// swiftlint:enable nesting
