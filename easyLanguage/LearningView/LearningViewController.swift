//
//  LearningViewController.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 26.11.2023.
//

import Foundation
import UIKit
import Shuffle

final class LearningViewController: UIViewController {
<<<<<<< Updated upstream
    
    private var knowCount: Int = 0
    private var dontKnowCount: Int = 0
    
    private var isRevert = false
    
    
    private lazy var cardStack: SwipeCardStack = {
        let stack = SwipeCardStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var nowLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "Знаю:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dontNowLabel: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        label.text = "Не знаю:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var resultsStackView: UIStackView = {
       let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.addArrangedSubview(nowLabel)
        stackView.addArrangedSubview(dontNowLabel)
       return stackView
    }()
    
=======
>>>>>>> Stashed changes
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Нажми на карточку, чтобы посмотреть перевод слова"
        return label
    }()
    private var isRevert = false
    private lazy var cardStack: SwipeCardStack = {
        let stack = SwipeCardStack()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.dataSource = self
        stack.delegate = self
        return stack
    }()
    private var correctCount: Int = 0
    private var incorrectCount: Int = 0
    private lazy var progressInfo: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        let correctLabel = UILabel()
        correctLabel.sizeToFit()
        correctLabel.text = "Знаю:"
        correctLabel.translatesAutoresizingMaskIntoConstraints = false
        let incorrectLabel = UILabel()
        incorrectLabel.sizeToFit()
        incorrectLabel.text = "Не знаю:"
        incorrectLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(correctLabel)
        stackView.addArrangedSubview(incorrectLabel)
        return stackView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cardStack)
        setupViews()
        setupDescriptionLabelConstraints()
        setupCardStackConstraints()
        setupProgressInfoConstraints()
    }
    private func setupViews() {
        title = "Тренировка слов"
        view.addSubview(descriptionLabel)
        view.addSubview(cardStack)
        view.addSubview(progressInfo)
        view.backgroundColor = .white
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
}
extension LearningViewController: SwipeCardStackDataSource {
    func cardStack(_ cardStack: Shuffle.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle.SwipeCard {
        setupCard(text: MockData.wordModel[index])
    }
    func numberOfCards(in cardStack: Shuffle.SwipeCardStack) -> Int {
        MockData.wordModel.count
    }
    private func setupCard(text: WordApiModel) -> SwipeCard {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        card.content = labelForCard(text: text.translations["ru"] ?? "")
        card.backgroundColor = UIColor.Catalog.LightYellow.categoryBackground
        card.layer.cornerRadius = 30
        card.setOverlays([.left: overlay(color: .green), .right: overlay(color: .red)])
        return card
    }
    private func labelForCard(text: String) -> UILabel {
        let label = UILabel()
        label.sizeToFit()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.text = text
        return label
    }
    private func rotateView(card: SwipeCard,
                            model: WordApiModel) {
        UIView.transition(with: card, duration: 0.5,
                          options: UIView.AnimationOptions.transitionFlipFromLeft) {
            if self.isRevert {
                card.content = self.labelForCard(text: model.translations["ru"] ?? "")
                self.isRevert.toggle()
            } else {
                card.content = self.labelForCard(text: model.translations["en"] ?? "")
                self.isRevert.toggle()
            }
<<<<<<< Updated upstream
        }, completion: nil)
    }
}

extension LearningViewController: SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        rotateView(card: cardStack.card(forIndexAt: index) ?? SwipeCard(), 
                   model: cardWords[index])
    }
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        print(index, direction)
        
        switch direction {
        case .left:
            knowCount += 1
            nowLabel.text = "Знаю: \(knowCount)"
            isRevert = false
        case .right:
            dontKnowCount += 1
            dontNowLabel.text = "Не знаю: \(dontKnowCount)"
            isRevert = false
        case .up:
            break
        case .down: 
            break
=======
>>>>>>> Stashed changes
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
extension LearningViewController: SwipeCardStackDelegate {
    func cardStack(_ cardStack: SwipeCardStack, didSelectCardAt index: Int) {
        rotateView(card: cardStack.card(forIndexAt: index) ?? SwipeCard(),
                   model: MockData.wordModel[index])
    }
    func cardStack(_ cardStack: SwipeCardStack, didSwipeCardAt index: Int, with direction: SwipeDirection) {
        guard let labels = progressInfo.arrangedSubviews as? [UILabel] else { return }
        switch direction {
        case .left:
            MockData.wordModel[index].isLearned = true // Предположил это
            correctCount += 1
            labels[0].text = "Знаю: \(correctCount)"
            isRevert = false
        case .right:
            incorrectCount += 1
            labels[1].text = "Не знаю: \(incorrectCount)"
            isRevert = false
        default:
            break
        }
    }
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        cardStack.reloadData()
    }
}
