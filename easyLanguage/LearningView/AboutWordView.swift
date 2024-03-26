//
//  AboutWordView.swift
//  easyLanguage
//
//  Created by Матвей Матюшко on 26.03.2024.
//

import Foundation
import UIKit


//final class AboutWordView: UIView {
//    var model: [WordUIModel]
//
//    private lazy var aboutWord: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fillEqually
//    
//        let categoryPhoto = UIImageView()
//        categoryPhoto.translatesAutoresizingMaskIntoConstraints = false
//        categoryPhoto.contentMode = .scaleAspectFit
//        
//        let categoryName = UILabel()
//        categoryName.font = TextStyle.bodyMedium.font
//        
//        stackView.addArrangedSubview(categoryName)
//        stackView.addArrangedSubview(categoryPhoto)
//        
//        return stackView
//    }()
//    
//    private lazy var progressInfo: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fillEqually
//        let correctLabel = UILabel()
//        correctLabel.font = TextStyle.bodyMedium.font
//        correctLabel.text =  NSLocalizedString("correctText", comment: "")
//        correctLabel.translatesAutoresizingMaskIntoConstraints = false
//        let incorrectLabel = UILabel()
//        incorrectLabel.font = TextStyle.bodyMedium.font
//        incorrectLabel.text =  NSLocalizedString("incorrectText", comment: "")
//        incorrectLabel.translatesAutoresizingMaskIntoConstraints = false
//        stackView.addArrangedSubview(correctLabel)
//        stackView.addArrangedSubview(incorrectLabel)
//        return stackView
//    }()
//    
//    private lazy var countText: UILabel = {
//        let text = UILabel()
//        text.translatesAutoresizingMaskIntoConstraints = false
//        text.text = "10/10"
//        return text
//    }()
//    
//    private lazy var lowerInfoBar: UIStackView = {
//        let stackView = UIStackView()
//        stackView.alignment = .center
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.distribution = .fillEqually
//        stackView.axis = .horizontal
//        
//        stackView.addArrangedSubview(aboutWord)
//        stackView.addArrangedSubview(progressInfo)
//        stackView.addArrangedSubview(countText)
//        return stackView
//    }()
//    
//    init(frame: CGRect, ) {
//        self.model = model
//        super.init(frame: frame)
//        self.translatesAutoresizingMaskIntoConstraints = false
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    func setupViews() {
//        self.addSubview(lowerInfoBar)
//    }
//}
