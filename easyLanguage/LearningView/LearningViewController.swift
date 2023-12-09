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
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = LearningViewConsts.firstDescription
        return label
    }()
     
   private let cardWords: [LearningWordsModel] = [
         LearningWordsModel(word: "Desk",
                            translation: "Стол"),
         LearningWordsModel(word: "Phone",
                            translation: "Телефон"),
         LearningWordsModel(word: "Fast",
                            translation: "Быстро"),
         LearningWordsModel(word: "House",
                            translation: "Дом"),
         LearningWordsModel(word: "Mouse",
                            translation: "Мышь"),
         LearningWordsModel(word: "Dog",
                            translation: "Собака"),
         LearningWordsModel(word: "Cat",
                            translation: "Кошка"),
         LearningWordsModel(word: "Car",
                            translation: "Машина"),
         LearningWordsModel(word: "Road",
                            translation: "Дорога"),
         LearningWordsModel(word: "City",
                            translation: "Город"),
         LearningWordsModel(word: "Bed",
                            translation: "Кровать"),
         LearningWordsModel(word: "Shirt",
                            translation: "Рубашка")
     ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(cardStack)
        setupViews()
        setupConstraints()
        cardStack.dataSource = self
        cardStack.delegate = self
    }
    
    private func setupViews() {
        navigationController?.title = "Тренировка слов"
        view.addSubview(descriptionLabel)
        view.addSubview(cardStack)
        view.addSubview(resultsStackView)
        view.backgroundColor = .white
    }
    
    private func setupConstraints() {
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 120).isActive = true
        descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        
        cardStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cardStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cardStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50).isActive = true
        cardStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50).isActive = true
        cardStack.topAnchor.constraint(equalTo: descriptionLabel.topAnchor, constant: 50).isActive = true
        cardStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        
        resultsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resultsStackView.topAnchor.constraint(equalTo: cardStack.bottomAnchor, constant: 20).isActive = true
    }
}

extension LearningViewController: SwipeCardStackDataSource {
    func cardStack(_ cardStack: Shuffle.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle.SwipeCard {
        return setupCard(fromWord: cardWords[index])
    }
    
    func numberOfCards(in cardStack: Shuffle.SwipeCardStack) -> Int {
        return cardWords.count
    }
    
    private func labelForCard(text: String) -> UILabel {
        let label = UILabel()
        label.sizeToFit()
        label.textAlignment = .center
        label.backgroundColor = UIColor.Catalog.LightYellow.categoryBackground
        label.text =  text
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 30
        return label
    }
    private func setupCard(fromWord text: LearningWordsModel) -> SwipeCard {
        let card = SwipeCard()
        card.swipeDirections = [.left, .right]
        card.content = labelForCard(text: text.word)
        
        let leftOverlay = UIView()
        leftOverlay.layer.masksToBounds = true
        leftOverlay.backgroundColor = .green
        leftOverlay.layer.cornerRadius = 30
        
        let rightOverlay = UIView()
        rightOverlay.backgroundColor = .red
        leftOverlay.backgroundColor = .green
        rightOverlay.layer.cornerRadius = 30
        
        card.setOverlays([.left: leftOverlay, .right: rightOverlay])
        return card
    }
    
    private func rotateView(card: SwipeCard, 
                            model: LearningWordsModel) {
        UIView.transition(with: card, duration: 0.5,
                          options: UIView.AnimationOptions.transitionFlipFromLeft,
                          animations: {
            if self.isRevert {
                card.content = self.labelForCard(text: model.word)
                self.isRevert.toggle()
            } else {
                card.content = self.labelForCard(text: model.translation)
                self.isRevert.toggle()
            }
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
        }
    }
    func cardStack(_ cardStack: SwipeCardStack, didUndoCardAt index: Int, from direction: SwipeDirection) {
        
    }
    func didSwipeAllCards(_ cardStack: SwipeCardStack) {
        cardStack.reloadData()
    }
}


