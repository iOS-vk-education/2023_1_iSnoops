//
//  MockCategoriesApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.11.2023.
//

import Foundation

struct MockData {
    static let topFiveWords: [TopFiveWordsApiModel] = [
        TopFiveWordsApiModel(topFiveWordsId: 0, title: ["ru": "Хомяк", "en": "Hamster"], level: "B1"),
        TopFiveWordsApiModel(topFiveWordsId: 1, title: ["ru": "Ластик", "en": "Rubber"], level: "A2"),
        TopFiveWordsApiModel(topFiveWordsId: 2, title: ["ru": "Полка", "en": "Shelf"], level: "C1"),
        TopFiveWordsApiModel(topFiveWordsId: 3, title: ["ru": "Царапать", "en": "Scratch"], level: "B2"),
        TopFiveWordsApiModel(topFiveWordsId: 4, title: ["ru": "Полотенце", "en": "Towel"], level: "A2")
    ]

    static var categoryModel: [CategoryApiModel] = [
        CategoryApiModel(categoryId: 0,
                         title: ["ru": "Технологии и информатика", "en": "Technology and computer science"],
                         imageLink: nil,
                         studiedWordsCount: 12,
                         totalWordsCount: 60,
                         createdDate: Date().addingTimeInterval(-32),
                         words: [WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date()),
                                 WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date()),
                                 WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date())
                         ]),
        CategoryApiModel(categoryId: 1,
                         title: ["ru": "Еда", "en": ""],
                         imageLink: nil,
                         studiedWordsCount: 5,
                         totalWordsCount: 12,
                         createdDate: Date().addingTimeInterval(-1),
                         words: [WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date()),
                                 WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date()),
                                 WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date())
                         ]),
        CategoryApiModel(categoryId: 2,
                         title: ["ru": "Путешествия", "en": ""],
                         imageLink: nil,
                         studiedWordsCount: 4,
                         totalWordsCount: 60,
                         createdDate: Date().addingTimeInterval(-3),
                         words: [WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date()),
                                 WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date()),
                                 WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date())
                         ]),
        CategoryApiModel(categoryId: 3,
                         title: ["ru": "Спорт", "en": ""],
                         imageLink: nil,
                         studiedWordsCount: 34,
                         totalWordsCount: 100,
                         createdDate: Date(),
                         words: [WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date()),
                                 WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date()),
                                 WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date())
                         ]),
        CategoryApiModel(categoryId: 4,
                         title: ["ru": "Спорт", "en": ""],
                         imageLink: nil,
                         studiedWordsCount: 34,
                         totalWordsCount: 100,
                         createdDate: Date(),
                         words: [WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date()),
                                 WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date()),
                                 WordApiModel(word: ["ru": "Царапать", "en": "Scratch"],
                                              isLearned: true,
                                              createdDate: Date())
                         ])
    ]
}
