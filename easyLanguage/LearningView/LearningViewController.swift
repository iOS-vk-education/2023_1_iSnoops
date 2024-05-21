//
//  LearningViewController.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 26.11.2023.
//

import Foundation
import UIKit
import Shuffle
import CoreData

final class LearningViewController: UIViewController {
    private enum CardsLanguage {
        static let rus = "ru"
        static let eng = "en"
    }
    private var categoryId: String = ""
    private let coreDataService = CoreDataService()

    private let service = LearningViewModel()
    private var model: [WordUIModel] = []
    private var modelForPost: [WordUIModel] = []
    private var modelForTopFivePost: [WordUIModel] = []
    private var cardsWereSwiped: Bool = false

    private var loadOneCategory: Bool = false

    private var isNeedLoadAll = true

    // MARK: UI
    private lazy var reloadButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.counterclockwise")?
            .withTintColor(.gray,
                           renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self,
                         action: #selector(reloadButtonTapped),
                         for: .touchUpInside)
        return button
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TextStyle.bodyBig.font
        label.textColor = .PrimaryColors.Font.secondary
        label.text = NSLocalizedString("descriptionText", comment: "")
        return label
    }()

    private lazy var cardStack: SwipeCardStack = {
        let stack = SwipeCardStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.dataSource = self
        stack.delegate = self
        stack.layer.shadowOffset = CGSize(width: 5,
                                          height: 5)
        stack.layer.shadowRadius = 2
        stack.layer.shadowOpacity = 0.3
        return stack
    }()

    private lazy var emptyWordsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("emptyWordsLabel", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TextStyle.bodyBig.font
        label.textColor = .PrimaryColors.Font.secondary
        return label
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(NSLocalizedString("continueLabel", comment: ""), for: .normal)
        button.backgroundColor = .PrimaryColors.Button.blue
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var toTheLeftButtonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.spacing = 0

        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.uturn.left")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        image.contentMode = .scaleAspectFit

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = TextStyle.bodyMedium.font
        button.setTitleColor(.gray, for: .normal)
        button.setTitle(NSLocalizedString("forgotTitle", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)

        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(button)
        return stackView
    }()

    private lazy var toTheRightButtonStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually

        let image = UIImageView()
        image.image = UIImage(systemName: "arrow.uturn.right")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        image.contentMode = .scaleAspectFit

        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = TextStyle.bodyMedium.font
        button.setTitleColor(.gray, for: .normal)
        button.setTitle(NSLocalizedString("rememberTitle", comment: ""), for: .normal)
        button.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)

        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(button)
        return stackView
    }()

    // MARK: Вспомогательные свойства
    private var isFlipped = false

    init(isNeedLoadAll: Bool = true, 
         categoryId: String = "",
         loadOneCategory: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        self.categoryId = categoryId
        self.isNeedLoadAll = isNeedLoadAll
        self.loadOneCategory = loadOneCategory
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: LyfeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupActivityIndicatorConstraints()
        setupEmptyWordsLabelConstraints()
        setupDescriptionLabelConstraints()
        setupCardStackConstraints()
        setupToTheLeftButtonConstraints()
        setupToTheRightButtonConstraints()
        setupReloadButtonConstraints()
        setupContinueButtonConstraints()
        hideEndLabels(state: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        descriptionLabel.isHidden = false
        activityIndicator.startAnimating()
        loadOneCategory ? loadOneWordsFromCoreData(categoryId: categoryId) : loadWordsFromCoreData()
        hideEndLabels(state: true)
        cardsWereSwiped = false
        modelForTopFivePost = []
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if cardsWereSwiped {
            postToTopFive()
        }
    }

    // MARK: Private methods
    private func setupViews() {
        view.backgroundColor = .PrimaryColors.Background.background
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(emptyWordsLabel)
        view.addSubview(continueButton)
        view.addSubview(descriptionLabel)
        view.addSubview(toTheLeftButtonStack)
        view.addSubview(toTheRightButtonStack)
        view.addSubview(reloadButton)
        view.addSubview(cardStack)
    }
    private func hideEndLabels(state: Bool) {
        continueButton.isHidden = state
        emptyWordsLabel.isHidden = state

    }
    private func setupReloadButtonConstraints() {
        reloadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                          constant: 10).isActive = true
        reloadButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                               constant: -20).isActive = true
    }

    private func setupDescriptionLabelConstraints() {
        descriptionLabel.topAnchor.constraint(equalTo: reloadButton.topAnchor,
                                              constant: 30).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 1).isActive = true
    }

    private func setupCardStackConstraints() {
        cardStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cardStack.heightAnchor.constraint(equalToConstant: view.frame.height / 2.5).isActive = true
        cardStack.widthAnchor.constraint(equalToConstant: view.frame.width / 1.2).isActive = true
    }

    private func setupToTheLeftButtonConstraints() {
        toTheLeftButtonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                     constant: -20).isActive = true
        toTheLeftButtonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                                                      constant: 20).isActive = true
    }
    private func setupToTheRightButtonConstraints() {
        toTheRightButtonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                      constant: -20).isActive = true
        toTheRightButtonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                                                        constant: -20).isActive = true
    }

    private func setupActivityIndicatorConstraints() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func setupEmptyWordsLabelConstraints() {
        emptyWordsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyWordsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func setupContinueButtonConstraints() {
        continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        continueButton.topAnchor.constraint(equalTo: emptyWordsLabel.bottomAnchor,
                                            constant: 20).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: view.frame.width / 3).isActive = true
    }

    private func loadLearningWords() {
        self.emptyWordsLabel.isHidden = true
        Task {
            do {
                self.model = try await service.loadWords()
                self.activityIndicator.stopAnimating()
                self.cardStack.reloadData()
            } catch {
                AlertManager.showEmptyLearningModel(on: self)
                self.model = []
            }
        }
    }

    private func loadWordsFromCoreData() {
        emptyWordsLabel.isHidden = false
        self.model = []
        let moc = coreDataService.persistentContainer.viewContext
        let wordsfetch = NSFetchRequest<WordCDModel>(entityName: "WordCDModel")
        wordsfetch.predicate = NSPredicate(format: "isLearned == %@", NSNumber(0))
        guard let coreModel = try? moc.fetch(wordsfetch) else {
            AlertManager.showEmptyLearningModel(on: self)
            return
        }
        if !coreModel.isEmpty {
            emptyWordsLabel.isHidden = true
        }
        for item in coreModel {
            self.model.append(WordUIModel(categoryId: item.categoryId ?? "error - error - error",
                                          translations: item.translations ?? [:],
                                          isLearned: item.isLearned,
                                          swipesCounter: Int(item.swipesCounter),
                                          id: item.id ?? ""))
        }

        activityIndicator.stopAnimating()
        cardStack.reloadData()
    }

    private func loadOneWordsFromCoreData(categoryId: String) {
        emptyWordsLabel.isHidden = false
        self.model = []
        let moc = coreDataService.persistentContainer.viewContext
        let wordsfetch = NSFetchRequest<WordCDModel>(entityName: "WordCDModel")
        let fPredicate = NSPredicate(format: "categoryId == %@", categoryId)
        let sPredicate = NSPredicate(format: "isLearned == %@", NSNumber(0))
        wordsfetch.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fPredicate, sPredicate])
        guard let coreModel = try? moc.fetch(wordsfetch) else {
            AlertManager.showEmptyLearningModel(on: self)
            return
        }
        if !coreModel.isEmpty {
            emptyWordsLabel.isHidden = true
        }
        for item in coreModel {
            self.model.append(WordUIModel(categoryId: item.categoryId ?? "error - error - error",
                                          translations: item.translations ?? [:],
                                          isLearned: item.isLearned,
                                          swipesCounter: Int(item.swipesCounter),
                                          id: item.id ?? ""))
        }

        activityIndicator.stopAnimating()
        cardStack.reloadData()
    }

    private func changeWordLearningCount(with id: String, change: Bool) {
        let moc = coreDataService.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<WordCDModel>(entityName: "WordCDModel")
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        guard let coreModel = try? moc.fetch(fetchRequest) else {
            AlertManager.showEmptyLearningModel(on: self)
            return
        }
        if !coreModel.isEmpty {
            guard let word = coreModel.first else {
                AlertManager.showEmptyLearningModel(on: self)
                return
            }
            if change {
                if word.swipesCounter < 5 {
                    word.swipesCounter += 1
                }
                if word.swipesCounter == 5 {
                    word.isLearned = true
                }
            } else {
                if word.swipesCounter > 0 {
                    word.swipesCounter -= 1
                }
            }
            try? moc.save()
        }
    }

    private func postToTopFive() {
        Task {
            do {
                try await service.postWords(words: modelForTopFivePost)
            } catch {
                AlertManager.showEmptyLearningModel(on: self)
            }
        }
    }
//
//    private func updateWord(words: WordUIModel) {
//        Task {
//            do {
//                try await service.updateWord(words: words)
//            } catch {
//                AlertManager.showEmptyLearningModel(on: self)
//            }
//        }
//    }

    @objc
    private func leftButtonTapped() {
        cardStack.swipe(.left, animated: true)
    }

    @objc
    private func rightButtonTapped() {
        cardStack.swipe(.right, animated: true)
    }

    @objc
    private func reloadButtonTapped() {
        hideEndLabels(state: true)
        cardStack.isHidden = false
        loadOneCategory ? loadOneWordsFromCoreData(categoryId: categoryId) : loadWordsFromCoreData()
    }

    @objc
    private func continueButtonTapped() {
        hideEndLabels(state: true)
        cardStack.isHidden = false
        loadOneCategory ? loadOneWordsFromCoreData(categoryId: categoryId) : loadWordsFromCoreData()
    }
}

// MARK: - Internal
extension LearningViewController {
    func learnCDCategory(with categoryId: String) {
        emptyWordsLabel.isHidden = true
        Task {
            do {
                model = try await service.loadCDCategory(with: categoryId)
                activityIndicator.stopAnimating()
                cardStack.reloadData()
            } catch {
                AlertManager.showEmptyLearningModel(on: self)
                model = []
            }
        }
    }

    func learnCategory(with categoryId: String) {
        emptyWordsLabel.isHidden = true
        Task {
            do {
                model = try await service.loadCategory(with: categoryId)
                activityIndicator.stopAnimating()
                cardStack.reloadData()
            } catch {
                AlertManager.showEmptyLearningModel(on: self)
                model = []
            }
        }
    }
}

// MARK: DataSource
extension LearningViewController: SwipeCardStackDataSource {
    func cardStack(_ cardStack: Shuffle.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle.SwipeCard {
        setupCard(text: model[index])
    }

    func numberOfCards(in cardStack: Shuffle.SwipeCardStack) -> Int {
        model.count
    }

    private func setupCard(text: WordUIModel) -> SwipeCard {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        card.content = LearningCardView(frame: card.frame,
                                        text: text.translations[CardsLanguage.rus] ?? "",
                                        counter: text.swipesCounter)
        card.backgroundColor = UIColor.Catalog.LightYellow.categoryBackground
        card.layer.cornerRadius = 30
        card.setOverlays([.left: overlay(color: UIColor.Catalog.Red.categoryBackground),
                          .right: overlay(color: UIColor.Catalog.Green.categoryBackground)])
        return card
    }

    private func rotateView(cards: SwipeCardStack,
                            model: WordUIModel,
                            index: Int) {
        descriptionLabel.isHidden = true
        let topFlip = UIView.AnimationOptions.transitionFlipFromTop
        let bottomFlip = UIView.AnimationOptions.transitionFlipFromBottom
        UIView.transition(with: cards,
                          duration: 0.5,
                          options: isFlipped ? topFlip : bottomFlip) {
            if self.isFlipped {
                cards.card(forIndexAt: index)?
                    .content = LearningCardView(frame: cards.frame,
                                                text: model.translations[CardsLanguage.rus] ?? "",
                                                counter: model.swipesCounter)
                self.isFlipped = false
            } else {
                cards.card(forIndexAt: index)?
                    .content = LearningCardView(frame: cards.frame,
                                                text: model.translations[CardsLanguage.eng] ?? "",
                                                counter: model.swipesCounter)
                self.isFlipped = true
            }
        }
    }

    private func overlay(color: UIColor) -> UIView {
        let overlay = UIView()
        overlay.layer.masksToBounds = true
        overlay.layer.cornerRadius = 30
        overlay.backgroundColor = color
        return overlay
    }
}

// MARK: Delegate
extension LearningViewController: SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        rotateView(cards: cardStack,
                   model: model[index],
                   index: index)
    }

    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        cardsWereSwiped = true
        switch direction {
        case .right:
//            model[index].swipesCounter += 1
//            if model[index].swipesCounter == 5 {
//                model[index].isLearned = true
//            }
//            updateWord(words: model[index])
//            modelForPost.append(model[index])
            changeWordLearningCount(with: model[index].id,
                                    change: true)
        case .left:
            changeWordLearningCount(with: model[index].id,
                                    change: false)
//            if model[index].swipesCounter != 0 {
//                model[index].swipesCounter -= 1
//            }
//            updateWord(words: model[index])
//            modelForPost.append(model[index])
            modelForTopFivePost.append(model[index])
        default:
            break
        }
    }

    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
            cardStack.isHidden = true
            self.hideEndLabels(state: false)
        }
    }
}
