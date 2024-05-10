//
//  DefaultData.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.11.2023.
//

 import Foundation

protocol IDefaultData {
    func getCategories() -> [CategoryModel]
    func getWords() -> [WordApiModel]
    func getTopFive() -> [WordUIModel] //FIXME: - переписать менеджер с добавлением слов в топ5 , тогда уйдет этот мок
}

struct DefaultData: IDefaultData {
    private init() {}

    static let shared: IDefaultData = DefaultData()

    private let linkedUUIDs = [
        UUID().uuidString,  // UUID for Технологии и информатика
        UUID().uuidString,  // UUID for Спорт
        UUID().uuidString,  // UUID for Еда
        UUID().uuidString,  // UUID for Путешествия
        UUID().uuidString   // UUID for Семья
    ]
}

// swiftlint:disable function_body_length
extension DefaultData {
    func getCategories() -> [CategoryModel] {
        [
            CategoryModel(
                title: "Технологии и информатика",
                imageLink: .informatics,
                createdDate: Date(),
                linkedWordsId: linkedUUIDs[0]
            ),
            CategoryModel(
                title: "Спорт",
                imageLink: .sport,
                createdDate: Date(),
                linkedWordsId: linkedUUIDs[1]
            ),
            CategoryModel(
                title: "Еда",
                imageLink: .food,
                createdDate: Date(),
                linkedWordsId: linkedUUIDs[2]
            ),
            CategoryModel(
                title: "Путешествия",
                imageLink: .travel,
                createdDate: Date(),
                linkedWordsId: linkedUUIDs[3]
            ),
            CategoryModel(
                title: "Семья",
                imageLink: .family,
                createdDate: Date(),
                linkedWordsId: linkedUUIDs[4]
            )
         ]
     }

     func getWords() -> [WordApiModel] {
         [
            // Технологии и информатика
            WordApiModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "Программирование", "en": "Programming"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "Разработка", "en": "Development"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "Алгоритм", "en": "Algorithm"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "Система", "en": "System"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "Информатика", "en": "Informatics"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),

            // Спорт
            WordApiModel(
                categoryId: linkedUUIDs[1],
                translations: ["ru": "Футбол", "en": "Football"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[1],
                translations: ["ru": "Теннис", "en": "Tennis"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[1],
                translations: ["ru": "Баскетбол", "en": "Basketball"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[1],
                translations: ["ru": "Бег", "en": "Running"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[1],
                translations: ["ru": "Плавание", "en": "Swimming"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),

            // Еда
            WordApiModel(
                categoryId: linkedUUIDs[2],
                translations: ["ru": "Паста", "en": "Pasta"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[2],
                translations: ["ru": "Фрукты", "en": "Fruits"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[2],
                translations: ["ru": "Пицца", "en": "Pizza"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[2],
                translations: ["ru": "Суп", "en": "Soup"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[2],
                translations: ["ru": "Десерт", "en": "Dessert"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),

            // Путешествия
            WordApiModel(
                categoryId: linkedUUIDs[3],
                translations: ["ru": "Путешествие", "en": "Travel"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[3],
                translations: ["ru": "Отпуск", "en": "Vacation"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[3],
                translations: ["ru": "Пейзаж", "en": "Landscape"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[3],
                translations: ["ru": "Культура", "en": "Culture"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[3],
                translations: ["ru": "Приключение", "en": "Adventure"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),

            // Семья
            WordApiModel(
                categoryId: linkedUUIDs[4],
                translations: ["ru": "Родители", "en": "Parents"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[4],
                translations: ["ru": "Дети", "en": "Children"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[4],
                translations: ["ru": "Брак", "en": "Marriage"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[4],
                translations: ["ru": "Любовь", "en": "Love"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[4],
                translations: ["ru": "Семья", "en": "Family"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            )
        ]
     }

    func getTopFive() -> [WordUIModel] {
        [
            WordUIModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "Программирование", "en": "Programming"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordUIModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "Разработка", "en": "Development"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordUIModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "Алгоритм", "en": "Algorithm"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordUIModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "Система", "en": "System"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
        ]
    }
}
// swiftlint:enable function_body_length

// swiftlint:disable line_length
private extension String {
    static let sport = "https://firebasestorage.googleapis.com/v0/b/easylanguage-e6d17.appspot.com/o/categories%2Fimage%2047.png?alt=media&token=081b6a7b-c88d-4474-871d-7820da8a1219"

    static let informatics = "https://firebasestorage.googleapis.com/v0/b/easylanguage-e6d17.appspot.com/o/categories%2Ffree-icon-computer-science-4025644.png?alt=media&token=37b96662-298d-4702-acea-5eabaa2c1fdf"

    static let food = "https://firebasestorage.googleapis.com/v0/b/easylanguage-e6d17.appspot.com/o/categories%2Ffree-icon-food-and-drink-5029077.png?alt=media&token=42ade0e2-719c-404d-b78a-74ba1dfc1ab2"

    static let travel = "https://firebasestorage.googleapis.com/v0/b/easylanguage-e6d17.appspot.com/o/categories%2Fimage%2045.png?alt=media&token=7a1f7e4b-e791-4a78-aa17-3ca384999660"

    static let family = "https://firebasestorage.googleapis.com/v0/b/easylanguage-e6d17.appspot.com/o/categories%2Fimage%2057.png?alt=media&token=34342948-dcfd-4b1a-8f65-b9558c01501a"
}
// swiftlint:enable line_length
