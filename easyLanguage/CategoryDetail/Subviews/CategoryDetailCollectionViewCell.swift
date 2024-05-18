//
//  CategoryDetailCollectionViewCell.swift
//  easyLanguage
//
//  Created by Grigoriy on 10.12.2023.
//

import UIKit

protocol CategoryDetailCellOutput {
    func didTapMarkAsLearned()
    func showTranslation()
}

final class CategoryDetailCollectionViewCell: UICollectionViewCell {
    private var cellBackgroundColor: UIColor?
    private let title = UILabel()
    private let markAsLearned = UIImageView()
    private var nativeTitle: String?
    private var foreignTitle: String?
    private var isFlipped = false

    private var wordUIModel: WordUIModel?
    private var categoryIndex = 0
    private var cellIndex = 0

    weak var delegate: InputWordsDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)

        setAppearance()
        addConstraints()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showTranslation))
        self.addGestureRecognizer(tapGesture)

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        self.addGestureRecognizer(longPressGesture)

        layer.cornerRadius = 15
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - life cycle
extension CategoryDetailCollectionViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()

        isFlipped = false
        foreignTitle = nil
        nativeTitle = nil
        title.text = nil
    }
}

// MARK: - internal methods
extension CategoryDetailCollectionViewCell {
    func cellConfigure(with categoryIndex: Int, cellIndex: Int, wordUIModel: WordUIModel) {
        self.wordUIModel = wordUIModel
        self.categoryIndex = categoryIndex
        self.cellIndex = cellIndex

        nativeTitle = wordUIModel.translations["ru"]
        foreignTitle = wordUIModel.translations["en"]
        if cellBackgroundColor == nil {
            setColors(with: categoryIndex)
        }
        updateMark(with: wordUIModel.isLearned)
        updateTitleLabel()
    }

    func setInputWords(with delegate: InputWordsDelegate) {
        self.delegate = delegate
    }
}

// MARK: - private methods
private extension CategoryDetailCollectionViewCell {
    func setColors(with categoryIndex: Int) {
        let categoryIndex = categoryIndex % Constants.colors.count
        let colors = Constants.colors[categoryIndex]
        let modifiedBackgroundColor = UIColor.generateRandomSimilarColor(from: colors.backgroundColor)

        backgroundColor = modifiedBackgroundColor
        cellBackgroundColor = modifiedBackgroundColor
        title.textColor = colors.textColor
    }

    func updateTitleLabel() {
        isFlipped ? (title.text = foreignTitle) : (title.text = nativeTitle)
    }

    func updateMark(with isLearned: Bool) {
        markAsLearned.image = UIImage(named: isLearned ? "bookmark.fill" : "bookmark")
    }
}

// MARK: - set appearance elements
private extension CategoryDetailCollectionViewCell {
    func setAppearance() {
        titleAppearance()
        markAsLearnedAppearence()
    }

    func titleAppearance() {
        title.numberOfLines = 0
        title.textAlignment = .center
    }

    func markAsLearnedAppearence() {
        markAsLearned.clipsToBounds = true
        markAsLearned.contentMode = .scaleAspectFit

        markAsLearned.isUserInteractionEnabled = true
        let tapGesture =  UITapGestureRecognizer(target: self, action: #selector(didTapMarkAsLearned))
        markAsLearned.addGestureRecognizer(tapGesture)
    }
}

// MARK: - set constraints
private extension CategoryDetailCollectionViewCell {
    func addConstraints() {
        [title, markAsLearned].forEach {
            contentView.addSubview($0)
        }
        setTitle()
        setMarkAsLearned()
    }

    func setTitle() {
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: topAnchor,
                                        constant: UIConstants.TitleLabel.padding).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor,
                                        constant: UIConstants.TitleLabel.padding).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor,
                                        constant: -UIConstants.TitleLabel.padding).isActive = true
        title.bottomAnchor.constraint(equalTo: bottomAnchor,
                                        constant: -UIConstants.TitleLabel.padding).isActive = true
    }

    func setMarkAsLearned() {
        markAsLearned.translatesAutoresizingMaskIntoConstraints = false
        markAsLearned.topAnchor.constraint(equalTo: topAnchor,
                                        constant: UIConstants.MarkAsLearned.topLeft).isActive = true
        markAsLearned.leadingAnchor.constraint(equalTo: leadingAnchor,
                                        constant: UIConstants.MarkAsLearned.topLeft).isActive = true
        markAsLearned.widthAnchor.constraint(equalToConstant: UIConstants.MarkAsLearned.size).isActive = true
        markAsLearned.heightAnchor.constraint(equalToConstant: UIConstants.MarkAsLearned.size).isActive = true
    }
}

// MARK: - Constants
// swiftlint:disable nesting
private extension CategoryDetailCollectionViewCell {
    struct Constants {
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
        struct TitleLabel {
            static let padding: CGFloat = 10.0
        }

        struct MarkAsLearned {
            static let topLeft: CGFloat = 10.0
            static let size: CGFloat = 35.0
        }
    }
}
// swiftlint:enable nesting

// MARK: - HandleLongPress
extension CategoryDetailCollectionViewCell: HandleLongPress {
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
        guard let id = wordUIModel?.id else {
            return
        }
        delegate?.showActionSheet(with: id)
    }
}

// MARK: - CategoryDetailCellOutput
extension CategoryDetailCollectionViewCell: CategoryDetailCellOutput {
    @objc
    func didTapMarkAsLearned() {
        wordUIModel?.isLearned.toggle()

        delegate?.changeIsLearned(with: cellIndex, 
                                  isLearned: wordUIModel?.isLearned ?? true,
                                  swipesCounter: wordUIModel?.isLearned ?? true ? 5 : 0)
        updateMark(with: (wordUIModel?.isLearned ?? true))
    }

    @objc
    func showTranslation() {
        let transitionOptions: UIView.AnimationOptions = .transitionFlipFromRight
        isFlipped = !isFlipped
        UIView.transition(with: self, duration: 0.65, options: transitionOptions, animations: { [weak self] in
            self?.updateTitleLabel()
        })
    }
}
