//
//  OnboardingViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.12.2023.
//

import UIKit

final class OnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        let finishButton = UIButton(type: .system)
        finishButton.setTitle("Finish Onboarding", for: .normal)
        finishButton.addTarget(self, action: #selector(finishOnboarding), for: .touchUpInside)

        finishButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(finishButton)

        NSLayoutConstraint.activate([
            finishButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            finishButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc private func finishOnboarding() {
        // Завершаем onboarding и сохраняем статус в UserDefaults
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
        dismiss(animated: true, completion: nil)
    }
}
