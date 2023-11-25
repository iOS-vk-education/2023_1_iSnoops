//
//  MockCategoriesApiModel.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.11.2023.
//

import Foundation
// swiftlint:disable all
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
                         studiedWordsCount: 0,
                         totalWordsCount: 10,
                         createdDate: Date().addingTimeInterval(-60),
                         linkedWordsId: UUID().uuidString),
        CategoryApiModel(categoryId: 1,
                         title: ["ru": "Спорт", "en": "Sport"],
                         imageLink: nil,
                         studiedWordsCount: 0,
                         totalWordsCount: 10,
                         createdDate: Date().addingTimeInterval(-6),
                         linkedWordsId: UUID().uuidString),
        CategoryApiModel(categoryId: 2,
                         title: ["ru": "Еда", "en": "Food"],
                         imageLink: nil,
                         studiedWordsCount: 0,
                         totalWordsCount: 10,
                         createdDate: Date(),
                         linkedWordsId: UUID().uuidString),
        CategoryApiModel(categoryId: 3,
                         title: ["ru": "Путешествия", "en": "Trips"],
                         imageLink: nil,
                         studiedWordsCount: 0,
                         totalWordsCount: 10,
                         createdDate: Date().addingTimeInterval(-10),
                         linkedWordsId: UUID().uuidString),
        CategoryApiModel(categoryId: 4,
                         title: ["ru": "Семья", "en": "Family"],
                         imageLink: nil,
                         studiedWordsCount: 0,
                         totalWordsCount: 10,
                         createdDate: Date().addingTimeInterval(-20),
                         linkedWordsId: UUID().uuidString)
    ]

    static var wordModel: [WordApiModel] = [
        WordApiModel(wordId: 1, linkedWordsId: categoryModel[0].linkedWordsId, words: ["ru": "Программирование", "en": "Programming"], isLearned: false, createdDate: Date()),
        WordApiModel(wordId: 2, linkedWordsId: categoryModel[0].linkedWordsId, words: ["ru": "Искусственный интеллект", "en": "Artificial Intelligence"], isLearned: true, createdDate: Date()),
        WordApiModel(wordId: 3, linkedWordsId: categoryModel[0].linkedWordsId, words: ["ru": "Веб-разработка", "en": "Web Development"], isLearned: false, createdDate: Date()),
        WordApiModel(wordId: 4, linkedWordsId: categoryModel[0].linkedWordsId, words: ["ru": "Компьютер", "en": "Computer"], isLearned: true, createdDate: Date()),
        WordApiModel(wordId: 5, linkedWordsId: categoryModel[0].linkedWordsId, words: ["ru": "Базы данных", "en": "Databases"], isLearned: false, createdDate: Date()),
        
        WordApiModel(wordId: 6, linkedWordsId: categoryModel[1].linkedWordsId, words: ["ru": "Футбол", "en": "Football"], isLearned: false, createdDate: Date()),
        WordApiModel(wordId: 7, linkedWordsId: categoryModel[1].linkedWordsId, words: ["ru": "Баскетбол", "en": "Basketball"], isLearned: true, createdDate: Date()),
        WordApiModel(wordId: 8, linkedWordsId: categoryModel[1].linkedWordsId, words: ["ru": "Теннис", "en": "Tennis"], isLearned: false, createdDate: Date()),
        WordApiModel(wordId: 9, linkedWordsId: categoryModel[1].linkedWordsId, words: ["ru": "Волейбол", "en": "Volleyball"], isLearned: true, createdDate: Date()),
        WordApiModel(wordId: 10, linkedWordsId: categoryModel[1].linkedWordsId, words: ["ru": "Бег", "en": "Running"], isLearned: false, createdDate: Date()),
        
        WordApiModel(wordId: 11, linkedWordsId: categoryModel[2].linkedWordsId, words: ["ru": "Пицца", "en": "Pizza"], isLearned: false, createdDate: Date()),
        WordApiModel(wordId: 12, linkedWordsId: categoryModel[2].linkedWordsId, words: ["ru": "Суши", "en": "Sushi"], isLearned: true, createdDate: Date()),
        WordApiModel(wordId: 13, linkedWordsId: categoryModel[2].linkedWordsId, words: ["ru": "Паста", "en": "Pasta"], isLearned: false, createdDate: Date()),
        WordApiModel(wordId: 14, linkedWordsId: categoryModel[2].linkedWordsId, words: ["ru": "Бургер", "en": "Burger"], isLearned: true, createdDate: Date()),
        WordApiModel(wordId: 15, linkedWordsId: categoryModel[2].linkedWordsId, words: ["ru": "Салат", "en": "Salad"], isLearned: false, createdDate: Date()),
        
        WordApiModel(wordId: 16, linkedWordsId: categoryModel[3].linkedWordsId, words: ["ru": "Путешествие", "en": "Travel"], isLearned: false, createdDate: Date()),
        WordApiModel(wordId: 17, linkedWordsId: categoryModel[3].linkedWordsId, words: ["ru": "Отпуск", "en": "Vacation"], isLearned: true, createdDate: Date()),
        WordApiModel(wordId: 18, linkedWordsId: categoryModel[3].linkedWordsId, words: ["ru": "Экскурсия", "en": "Excursion"], isLearned: false, createdDate: Date()),
        WordApiModel(wordId: 19, linkedWordsId: categoryModel[3].linkedWordsId, words: ["ru": "Пейзаж", "en": "Landscape"], isLearned: true, createdDate: Date()),
        WordApiModel(wordId: 20, linkedWordsId: categoryModel[3].linkedWordsId, words: ["ru": "Отель", "en": "Hotel"], isLearned: false, createdDate: Date()),
        
        WordApiModel(wordId: 21, linkedWordsId: categoryModel[4].linkedWordsId, words: ["ru": "Мама", "en": "Mom"], isLearned: false, createdDate: Date()),
        WordApiModel(wordId: 22, linkedWordsId: categoryModel[4].linkedWordsId, words: ["ru": "Папа", "en": "Dad"], isLearned: true, createdDate: Date()),
        WordApiModel(wordId: 23, linkedWordsId: categoryModel[4].linkedWordsId, words: ["ru": "Брат", "en": "Brother"], isLearned: false, createdDate: Date()),
        WordApiModel(wordId: 24, linkedWordsId: categoryModel[4].linkedWordsId, words: ["ru": "Сестра", "en": "Sister"], isLearned: true, createdDate: Date()),
        WordApiModel(wordId: 25, linkedWordsId: categoryModel[4].linkedWordsId, words: ["ru": "Дом", "en": "Home"],  isLearned: true, createdDate: Date())
        ]

    static let categoryModelLastId: Int = categoryModel.last?.categoryId ?? 0
    static func wordModelLastId(with categoryModelId: Int) -> Int? {
        guard let lastCategory = categoryModel.last(where: { $0.categoryId == categoryModelId }) else {
            return nil
        }

        return wordModel.last(where: { $0.linkedWordsId == lastCategory.linkedWordsId })?.wordId
    }
}
// swiftlint:enable all
