//
//  TopFiveView.swift
//  easyLanguage
//
//  Created by Grigoriy on 26.10.2023.
//

import UIKit

final class TopFiveView: UIView {

    var topFiveModel: [TopFiveWordsModel] = [TopFiveWordsModel]()
    private let model = CatalogModel()
    private let titleLabel = UILabel()
    private let adviceLabel = UILabel()
    private lazy var topFiveCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal

        let topFiveCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        topFiveCollectionView.showsHorizontalScrollIndicator = false
        topFiveCollectionView.backgroundColor = .PrimaryColors.Background.customBackground
        topFiveCollectionView.delegate = self
        topFiveCollectionView.dataSource = self
        topFiveCollectionView.register(TopFiveCollectionViewCell.self,
                                       forCellWithReuseIdentifier: "topFiveWordsCollectionView")
        if let flowLayout = topFiveCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = UIScreen.main.bounds.width / 21.8
        }
        return topFiveCollectionView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadTopFiveWords()
        [topFiveCollectionView, titleLabel, adviceLabel].forEach {
            self.addSubview($0)
        }
        setVisualAppearance()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - life circle
extension TopFiveView {
    override func layoutSubviews() {
        super.layoutSubviews()
        setTitleLabel()
        setTopFiveCollectionView()
        setAdviceLabel()
    }
}

// MARK: - private methods
private extension TopFiveView {
    func loadTopFiveWords() {
        model.loadTopFiveWords { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
                self.topFiveModel = data
                DispatchQueue.main.async {
                    self.topFiveCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func setVisualAppearance() {
        titleLabel.textColor = .black
        titleLabel.text = TopFiveView.Consts.titleText
        adviceLabel.text = TopFiveView.Consts.adviceText
        adviceLabel.textColor = .gray
    }

    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: UIConstants.TitleLabel.width).isActive = true
        titleLabel.sizeToFit()
    }

    func setTopFiveCollectionView() {
        topFiveCollectionView.translatesAutoresizingMaskIntoConstraints = false
        topFiveCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
                                                   constant: UIConstants.TopFiveCollectionView.top).isActive = true
        topFiveCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topFiveCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        topFiveCollectionView.heightAnchor.constraint(equalToConstant: self.frame.width / 3).isActive = true
    }

    func setAdviceLabel() {
        adviceLabel.translatesAutoresizingMaskIntoConstraints = false
        adviceLabel.topAnchor.constraint(equalTo: topFiveCollectionView.bottomAnchor,
                                         constant: 5).isActive = true
        adviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        adviceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        adviceLabel.heightAnchor.constraint(equalToConstant: UIConstants.AdviceLabel.height).isActive = true
    }
}

// MARK: - Constants
// swiftlint:disable nesting
private extension TopFiveView {
    struct Consts {
        static let titleText: String = "Tоп 5"
        static let adviceText: String = "Для перевода слова нажмите на карточку"
    }

    struct UIConstants {
        struct TitleLabel {
            static let width: CGFloat = 54.0
        }

        struct TopFiveCollectionView {
            static let top: CGFloat = 18.0
        }

        struct AdviceLabel {
            static let height: CGFloat = 16.0
        }
    }
}
// swiftlint:enable nesting
