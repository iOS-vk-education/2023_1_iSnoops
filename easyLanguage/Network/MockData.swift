//
//  MockCategoriesApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.11.2023.
//

import Foundation

struct MockData {
    static let topFiveWords: [TopFiveWordsApiModel] = [
        TopFiveWordsApiModel(translations: ["ru": "Хомяк", "en": "Hamster"],
                             level: "B1"),
        TopFiveWordsApiModel(translations: ["ru": "Ластик", "en": "Rubber"],
                             level: "A2"),
        TopFiveWordsApiModel(translations: ["ru": "Полка", "en": "Shelf"],
                             level: "C1"),
        TopFiveWordsApiModel(translations: ["ru": "Царапать", "en": "Scratch"],
                             level: "B2"),
        TopFiveWordsApiModel(translations: ["ru": "Полотенце", "en": "Towel"],
                             level: "A2")
    ]

    static var categoryModel: [CategoryApiModel] = [
        CategoryApiModel(title: "Технологии и информатика",
                         imageLink: nil,
                         createdDate: Date().addingTimeInterval(-60),
                         linkedWordsId: UUID().uuidString),
        CategoryApiModel(title: "Спорт",
                         imageLink: nil,
                         createdDate: Date().addingTimeInterval(-6),
                         linkedWordsId: UUID().uuidString),
        CategoryApiModel(title: "Еда",
                         imageLink: nil,
                         createdDate: Date(),
                         linkedWordsId: UUID().uuidString),
        CategoryApiModel(title: "Путешествия",
                         imageLink: nil,
                         createdDate: Date().addingTimeInterval(-10),
                         linkedWordsId: UUID().uuidString),
        CategoryApiModel(title: "Семья",
                         imageLink: nil,
                         createdDate: Date().addingTimeInterval(-20),
                         linkedWordsId: UUID().uuidString)
    ]

    static var wordModel: [WordApiModel] = [
        WordApiModel(linkedCategoryId: categoryModel[0].linkedWordsId,
                     translations: ["ru": "Кодирование", "en": "Coding"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[0].linkedWordsId,
                     translations: ["ru": "Программирование", "en": "Programming"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[0].linkedWordsId,
                     translations: ["ru": "Разработка", "en": "Development"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[0].linkedWordsId,
                     translations: ["ru": "Алгоритм", "en": "Algorithm"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[0].linkedWordsId,
                     translations: ["ru": "Система", "en": "System"],
                     isLearned: false),

        WordApiModel(linkedCategoryId: categoryModel[1].linkedWordsId,
                     translations: ["ru": "Футбол", "en": "Football"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[1].linkedWordsId,
                     translations: ["ru": "Теннис", "en": "Tennis"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[1].linkedWordsId,
                     translations: ["ru": "Баскетбол", "en": "Basketball"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[1].linkedWordsId,
                     translations: ["ru": "Бег", "en": "Running"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[1].linkedWordsId,
                     translations: ["ru": "Плавание", "en": "Swimming"],
                     isLearned: false),

        WordApiModel(linkedCategoryId: categoryModel[2].linkedWordsId,
                     translations: ["ru": "Паста", "en": "Pasta"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[2].linkedWordsId,
                     translations: ["ru": "Фрукты", "en": "Fruits"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[2].linkedWordsId,
                     translations: ["ru": "Пицца", "en": "Pizza"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[2].linkedWordsId,
                     translations: ["ru": "Суп", "en": "Soup"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[2].linkedWordsId,
                     translations: ["ru": "Десерт", "en": "Dessert"],
                     isLearned: false),

        WordApiModel(linkedCategoryId: categoryModel[3].linkedWordsId,
                     translations: ["ru": "Путешествие", "en": "Travel"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[3].linkedWordsId,
                     translations: ["ru": "Отпуск", "en": "Vacation"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[3].linkedWordsId,
                     translations: ["ru": "Пейзаж", "en": "Landscape"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[3].linkedWordsId,
                     translations: ["ru": "Культура", "en": "Culture"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[3].linkedWordsId,
                     translations: ["ru": "Приключение", "en": "Adventure"],
                     isLearned: false),

        WordApiModel(linkedCategoryId: categoryModel[4].linkedWordsId,
                     translations: ["ru": "Родители", "en": "Parents"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[4].linkedWordsId,
                     translations: ["ru": "Дети", "en": "Children"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[4].linkedWordsId,
                     translations: ["ru": "Брак", "en": "Marriage"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[4].linkedWordsId,
                     translations: ["ru": "Любовь", "en": "Love"],
                     isLearned: false),
        WordApiModel(linkedCategoryId: categoryModel[4].linkedWordsId,
                     translations: ["ru": "Семья", "en": "Family"],
                     isLearned: false)
        ]
}
