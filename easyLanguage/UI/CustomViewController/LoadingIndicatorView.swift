//
//  LoadingIndicatorView.swift
//  easyLanguage
//
//  Created by Grigoriy on 08.12.2023.
//

import UIKit

final class LoadingIndicatorView: UIView {
    private let activityIndicatorView = UIActivityIndicatorView()
    private let loadLabel =  UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        [loadLabel, activityIndicatorView].forEach {
            addSubview($0)
        }

        setVisualAppearance()
        setActivityIndicatorView()
        setLoadLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - open methods
extension LoadingIndicatorView {
    func startLoadActivity() {
        activityIndicatorView.startAnimating()
    }

    func stopLoadActivity() {
        activityIndicatorView.stopAnimating()
    }
}

// MARK: - private methods
private extension LoadingIndicatorView {
    func setVisualAppearance() {
        backgroundColor = .white
        loadLabel.text = Constants.LoadLabel.text
        loadLabel.textAlignment = .center
        activityIndicatorView.hidesWhenStopped = true
    }

    func setActivityIndicatorView() {
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicatorView.topAnchor.constraint(equalTo: topAnchor,
                                                   constant: UIConstants.top).isActive = true
    }

    func setLoadLabel() {
        loadLabel.translatesAutoresizingMaskIntoConstraints = false
        loadLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        loadLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loadLabel.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor,
                                       constant: UIConstants.top).isActive = true
        loadLabel.sizeToFit()
    }
}

// MARK: - Constants
// swiftlint:disable nesting
extension LoadingIndicatorView {
    struct Constants {
        struct LoadLabel {
            static let text = "Loading..."
        }
    }

    struct UIConstants {
        static let top: CGFloat = 10
    }
}
// swiftlint:enable nesting
