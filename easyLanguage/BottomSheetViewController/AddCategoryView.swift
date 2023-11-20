//
//  AddPhotoView.swift
//  AddCategoryView
//
//  Created by Grigoriy on 20.11.2023.
//

import UIKit

final class AddCategoryView: UIView {
    private let imageView: UIImageView = UIImageView()
    private let titleLabel: UILabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        [imageView, titleLabel].forEach {
            addSubview($0)
        }
        setVisualAppearance()
        setImageView()
        setTitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AddCategoryView {
    func setImage(with image: UIImage) {
        self.imageView.image = image
    }
}

private extension AddCategoryView {
    func setVisualAppearance() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = Consts.ImageView.image
        titleLabel.text = Consts.TitleLabel.text
        titleLabel.textAlignment = .center
    }

    func setImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: widthAnchor).isActive = true
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }
}
// swiftlint:disable nesting
private extension AddCategoryView {
    struct Consts {
        struct ImageView {
            static let image: UIImage = UIImage(named: "plus-signIconImage")!
        }

        struct TitleLabel {
            static let text: String = "добавить фото"
        }
    }
}
// swiftlint:enable nesting
