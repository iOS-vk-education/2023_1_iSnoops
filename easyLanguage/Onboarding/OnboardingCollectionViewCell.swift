//
//  OnboardingCollectionViewCell.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.12.2023.
//

import UIKit

final class OnboardingCollectionViewCell: UICollectionViewCell {
    private let slideImageView = UIImageView()
    private let slideTitle = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setAppearance()
        addConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - public func
extension OnboardingCollectionViewCell {
    func setup(_ slide: OnboardingSlide) {
        slideImageView.image = slide.image
        slideTitle.text = slide.title
    }
}

// MARK: - set appearance
private extension OnboardingCollectionViewCell {
    func setAppearance() {
        setSlideImageViewAppearance()
        setSlideTitleAppearance()
    }

    func setSlideImageViewAppearance() {
        slideImageView.contentMode = .scaleAspectFit
        slideImageView.clipsToBounds = true
    }

    func setSlideTitleAppearance() {
        slideTitle.textAlignment = .center
        slideTitle.numberOfLines = 0
    }
}

// MARK: - set constraints
private extension OnboardingCollectionViewCell {
    func addConstraints() {
        [slideImageView, slideTitle].forEach {
            addSubview($0)
        }
        setSlideImageView()
        setSlideTitle()
    }

    func setSlideImageView() {
        slideImageView.translatesAutoresizingMaskIntoConstraints = false
        slideImageView.topAnchor.constraint(equalTo: topAnchor, constant: 150).isActive = true
        slideImageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        slideImageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        slideImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
    }

    func setSlideTitle() {
        slideTitle.translatesAutoresizingMaskIntoConstraints = false
        slideTitle.topAnchor.constraint(equalTo: slideImageView.bottomAnchor, constant: 8).isActive = true
        slideTitle.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: UIConstants.horizontally).isActive = true
        slideTitle.trailingAnchor.constraint(equalTo: trailingAnchor,
                                             constant: -UIConstants.horizontally).isActive = true
        slideTitle.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

// MARK: - Constants
private extension OnboardingCollectionViewCell {
    struct UIConstants {
        static let horizontally: CGFloat = 20
    }
}
