//
//  SplashViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 05.05.2024.
//

import UIKit

final class SplashViewController: UIViewController {
     lazy var background: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "Launch")
        return imageView
    }()

    let logo: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "icon")
        return imageView
    }()

    private let text = UILabel()

    // MARK: - Life circle
    override func viewDidLoad() {
        super.viewDidLoad()

        [background, logo, text].forEach {
            view.addSubview($0)
        }
        setConstraints()
    }

    private func setConstraints() {
        background.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        background.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        background.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        background.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        logo.topAnchor.constraint(equalTo: view.topAnchor, constant: -0).isActive = true
        logo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logo.widthAnchor.constraint(equalToConstant: CGFloat.size).isActive = true
        logo.heightAnchor.constraint(equalToConstant: CGFloat.size).isActive = true
    }
}

private extension CGFloat {
    static let top: CGFloat = 55
    static let size: CGFloat = 80
}
