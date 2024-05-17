//
//  LearningCardView.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 17.05.2024.
//

import Foundation
import UIKit

final class LearningCardView: UIView {
    var word: String
    var counter: Int

    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.text = word
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()

    lazy var learningCountLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.text = "\(counter)/5"
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()

    init(frame: CGRect, text: String, counter: Int) {
        self.word = text
        self.counter = counter
        super.init(frame: frame)
        setupViews()
        setUpWordLabelConstrains()
        setUpLearningCountLabelConstrains()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        layer.masksToBounds = true
        layer.cornerRadius = 30
        backgroundColor = .clear
        addSubview(learningCountLabel)
        addSubview(wordLabel)
    }

    private func setUpWordLabelConstrains() {
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        wordLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }

    private func setUpLearningCountLabelConstrains() {
        learningCountLabel.translatesAutoresizingMaskIntoConstraints = false
        learningCountLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        learningCountLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50).isActive = true
    }
}
