//
//  CategoryCollectionViewCell.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

protocol HandleLongPress {
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer)
}

final class CategoryCollectionViewCell: UICollectionViewCell {

    private let backgroundLevelView = UIView()
    private let titleLabel = UILabel()
    private let imageView = UIImageView()
    private let progressLabel = UILabel()

    private var id: String?
    weak var delegate: InputCategoriesDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setVisualAppearance()
        backgroundLevelView.addSubview(imageView)
        [backgroundLevelView, titleLabel, progressLabel].forEach {
            contentView.addSubview($0)
        }
        setBackgroundLevelView()
        setImageView()
        setTitleLabel()
        setProgressLabel()
        setupLabels()

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(longPressGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - open methods
extension CategoryCollectionViewCell {
    func cellConfigure(with model: CategoryUIModel, at indexPath: IndexPath) {
        id = model.linkedWordsId
        setupColorsForCategory(with: model.index)
        setupProgressAndTitleLabels(with: model)
        imageView.image = model.image
    }

    func setDelegate(with delegate: InputCategoriesDelegate) {
        self.delegate = delegate
    }
}

// MARK: - private methods
private extension CategoryCollectionViewCell {
    func setVisualAppearance() {
        layer.cornerRadius = Constants.cornerRadius
        [progressLabel, titleLabel].forEach {
            $0.numberOfLines = 0
            $0.textAlignment = .center
            $0.font = TextStyle.bodyMedium.font
        }
        backgroundLevelView.backgroundColor = .white
        backgroundLevelView.layer.cornerRadius =  Constants.cornerRadius
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
    }

    func setupColorsForCategory(with index: Int) {
        let colors = Constants.colors[index % Constants.colors.count]

        backgroundColor = colors.backgroundColor
        [progressLabel, titleLabel].forEach { $0.textColor = colors.textColor }
    }

    func setupLabels() {
        [progressLabel, titleLabel].forEach {
            $0.numberOfLines = 0
            $0.textAlignment = .center
        }
    }

    func setupProgressAndTitleLabels(with model: CategoryUIModel) {
        progressLabel.text = "\(model.studiedWordsCount)/\(model.totalWordsCount)"
        titleLabel.text = model.title
    }

    func setBackgroundLevelView() {
        backgroundLevelView.translatesAutoresizingMaskIntoConstraints = false
        backgroundLevelView.topAnchor.constraint(equalTo: topAnchor,
                                                 constant: UIConstants.BackgroundLevelView.top).isActive = true
        backgroundLevelView.trailingAnchor.constraint(equalTo: trailingAnchor, constant:
                                                    -UIConstants.BackgroundLevelView.trailing).isActive = true
        backgroundLevelView.widthAnchor.constraint(equalToConstant:
                                                    frame.width / 4).isActive = true
        backgroundLevelView.heightAnchor.constraint(equalToConstant:
                                                    frame.width / 4).isActive = true
    }

    func setImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: backgroundLevelView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: backgroundLevelView.centerXAnchor).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: frame.width / 5).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: frame.width / 5).isActive = true
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                            constant: UIConstants.TitleLabel.horizontally).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -UIConstants.TitleLabel.horizontally).isActive = true
    }

    func setProgressLabel() {
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        progressLabel.topAnchor.constraint(equalTo: topAnchor,
                                           constant: frame.width / 8).isActive = true
        progressLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                           constant: frame.width / 8).isActive = true
    }
}

// MARK: - CategoryCellInput
extension CategoryCollectionViewCell: HandleLongPress {
    @objc
    func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            generateHapticFeedback()
            showDeleteConfirmation()
        }
    }

    private func generateHapticFeedback() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
    }

    private func showDeleteConfirmation() {
        delegate?.showActionSheet(with: id ?? "")
    }
}

// MARK: - Constants
private extension CategoryCollectionViewCell {
    // swiftlint:disable nesting
    struct Constants {
        static let cornerRadius: CGFloat = 15
        static let colors: [(backgroundColor: UIColor, textColor: UIColor)] = [
            (.Catalog.Green.categoryBackground, .Catalog.Green.categoryText),
            (.Catalog.Purple.categoryBackground, .Catalog.Purple.categoryText),
            (.Catalog.LightYellow.categoryBackground, .Catalog.LightYellow.categoryText),
            (.Catalog.Yellow.categoryBackground, .Catalog.Yellow.categoryText),
            (.Catalog.Red.categoryBackground, .Catalog.Red.categoryText),
            (.Catalog.Blue.categoryBackground, .Catalog.Blue.categoryText),
            (.Catalog.Cyan.categoryBackground, .Catalog.Cyan.categoryText),
            (.Catalog.Pink.categoryBackground, .Catalog.Pink.categoryText)
        ]
    }

    struct UIConstants {
        struct BackgroundLevelView {
            static let top: CGFloat = 15.0
            static let trailing: CGFloat = 15.0
        }

        struct TitleLabel {
            static let horizontally: CGFloat = 15.0
        }
    }
}
// swiftlint:enable nesting
