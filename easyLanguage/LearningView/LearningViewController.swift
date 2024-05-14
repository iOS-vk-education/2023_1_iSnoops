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

    private let coreDataService = CoreDataService()

    private let service = LearningViewModel()
    private var model: [WordUIModel] = []
    private var modelForPost: [WordUIModel] = []
    private var modelForTopFivePost: [WordUIModel] = []
    private var cardsWereSwiped: Bool = false

    // MARK: UI
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = TextStyle.bodyBig.font
        label.text = NSLocalizedString("descriptionText", comment: "")
        return label
    }()

    private lazy var cardStack: SwipeCardStack = {
        let stack = SwipeCardStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.dataSource = self
        stack.delegate = self
        return stack
    }()

    private lazy var progressInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        let correctLabel = UILabel()
        correctLabel.font = TextStyle.bodyMedium.font
        correctLabel.text =  NSLocalizedString("correctText", comment: "")
        correctLabel.translatesAutoresizingMaskIntoConstraints = false
        let incorrectLabel = UILabel()
        incorrectLabel.font = TextStyle.bodyMedium.font
        incorrectLabel.text =  NSLocalizedString("incorrectText", comment: "")
        incorrectLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(correctLabel)
        stackView.addArrangedSubview(incorrectLabel)
        return stackView
    }()

    private lazy var emptyWordsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("emptyWordsLabel", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 220, y: 220, width: 100, height: 100))
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()

    // MARK: Вспомогательные свойства
    private var isFlipped = false

    private var correctCount: Int = 0
    private var incorrectCount: Int = 0

    // MARK: LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupEmptyWordsLabelConstraints()
        setupDescriptionLabelConstraints()
        setupCardStackConstraints()
        setupProgressInfoConstraints()
        coreDataService.loadStore()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        correctCount = 0
        incorrectCount = 0
//        loadLearningWords()
        loadWordsFromCoreData()
        cardsWereSwiped = false
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
        let title = NSLocalizedString("wordTrainingTitle", comment: "")
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        view.addSubview(emptyWordsLabel)
        emptyWordsLabel.isHidden = true
        view.addSubview(descriptionLabel)
        view.addSubview(progressInfo)
        view.addSubview(cardStack)
    }

    private func setupDescriptionLabelConstraints() {
        descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        descriptionLabel.widthAnchor.constraint(equalToConstant: view.frame.width / 1).isActive = true
    }

    private func setupCardStackConstraints() {
        cardStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cardStack.heightAnchor.constraint(equalToConstant: view.frame.height / 1.7).isActive = true
        cardStack.widthAnchor.constraint(equalToConstant: view.frame.width / 1.2).isActive = true
    }

    private func setupProgressInfoConstraints() {
        progressInfo.topAnchor.constraint(equalTo: cardStack.bottomAnchor, constant: 20).isActive = true
        progressInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    private func setupEmptyWordsLabelConstraints() {
        emptyWordsLabel.isHidden = true
        emptyWordsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyWordsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    private func setupActivityIndicatorConstraints() {
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
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
        self.model = []

        let moc = coreDataService.persistentContainer.viewContext
        let wordsfetch = NSFetchRequest<WordCDModel>(entityName: "WordCDModel")

        guard let coreModel = try? moc.fetch(wordsfetch) else { return }
        for item in coreModel {
            self.model.append(WordUIModel(categoryId: item.categoryId ?? "error - error - error",
                                     translations: item.translations ?? [:],
                                     isLearned: item.isLearned,
                                     swipesCounter: Int(item.swipesCounter),
                                     id: item.id ?? ""))
        }
        cardStack.reloadData()
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

    private func updateWord(words: WordUIModel) {
        Task {
            do {
                try await service.updateWord(words: words)
            } catch {
                AlertManager.showEmptyLearningModel(on: self)
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
        card.content = labelForCard(text: text.translations["ru"] ?? "")
        card.backgroundColor = UIColor.Catalog.LightYellow.categoryBackground
        card.layer.cornerRadius = 30
        card.setOverlays([.left: overlay(color: UIColor.Catalog.Red.categoryBackground),
                          .right: overlay(color: UIColor.Catalog.Green.categoryBackground)])
        return card
    }

    private func labelForCard(text: String) -> UILabel {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.text = text
        return label
    }

    private func rotateView(card: SwipeCard,
                            model: WordUIModel) {
        UIView.transition(with: card, duration: 0.5,
                          options: UIView.AnimationOptions.transitionFlipFromLeft) {
            if self.isFlipped {
                card.content = self.labelForCard(text: model.translations["ru"] ?? "")
                self.isFlipped.toggle()
            } else {
                card.content = self.labelForCard(text: model.translations["en"] ?? "")
                self.isFlipped.toggle()
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
        rotateView(card: cardStack.card(forIndexAt: index) ?? SwipeCard(),
                   model: model[index])
    }

    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        cardsWereSwiped = true
        guard let labels = progressInfo.arrangedSubviews as? [UILabel] else { return }
        switch direction {
        case .right:
            model[index].swipesCounter += 1
            if model[index].swipesCounter == 5 {
                model[index].isLearned = true
            }
            updateWord(words: model[index])
            modelForPost.append(model[index])
            correctCount += 1
            labels[0].text = "\(NSLocalizedString("correctText", comment: "")) \(correctCount)"
            isFlipped = false
        case .left:
            if model[index].swipesCounter != 0 {
                model[index].swipesCounter -= 1
            }
            updateWord(words: model[index])
            modelForPost.append(model[index])
            modelForTopFivePost.append(model[index])
            print("post ----- \(modelForPost)")
            incorrectCount += 1
            labels[1].text = "\(NSLocalizedString("incorrectText", comment: "")) \(incorrectCount)"
            isFlipped = false
        default:
            break
        }
    }

    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        emptyWordsLabel.isHidden = false
    }
}
