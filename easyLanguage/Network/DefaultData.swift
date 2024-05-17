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
                title: "технологии и информатика",
                imageLink: .informatics,
                createdDate: Date(),
                linkedWordsId: linkedUUIDs[0],
                isDefault: true
            ),
            CategoryModel(
                title: "спорт",
                imageLink: .sport,
                createdDate: Date(),
                linkedWordsId: linkedUUIDs[1],
                isDefault: true
            ),
            CategoryModel(
                title: "еда",
                imageLink: .food,
                createdDate: Date(),
                linkedWordsId: linkedUUIDs[2],
                isDefault: true
            ),
            CategoryModel(
                title: "путешествия",
                imageLink: .travel,
                createdDate: Date(),
                linkedWordsId: linkedUUIDs[3],
                isDefault: true
            ),
            CategoryModel(
                title: "семья",
                imageLink: .family,
                createdDate: Date(),
                linkedWordsId: linkedUUIDs[4],
                isDefault: true
            )
         ]
     }

     func getWords() -> [WordApiModel] {
         [
            // Технологии и информатика
            WordApiModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "программирование", "en": "programming"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "разработка", "en": "development"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "алгоритм", "en": "algorithm"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "система", "en": "system"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "информатика", "en": "informatics"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),

            // Спорт
            WordApiModel(
                categoryId: linkedUUIDs[1],
                translations: ["ru": "футбол", "en": "football"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[1],
                translations: ["ru": "теннис", "en": "tennis"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[1],
                translations: ["ru": "баскетбол", "en": "basketball"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[1],
                translations: ["ru": "бег", "en": "running"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[1],
                translations: ["ru": "плавание", "en": "swimming"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),

            // Еда
            WordApiModel(
                categoryId: linkedUUIDs[2],
                translations: ["ru": "паста", "en": "pasta"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[2],
                translations: ["ru": "фрукты", "en": "fruits"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[2],
                translations: ["ru": "пицца", "en": "pizza"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[2],
                translations: ["ru": "суп", "en": "soup"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[2],
                translations: ["ru": "десерт", "en": "dessert"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),

            // Путешествия
            WordApiModel(
                categoryId: linkedUUIDs[3],
                translations: ["ru": "путешествие", "en": "travel"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[3],
                translations: ["ru": "отпуск", "en": "vacation"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[3],
                translations: ["ru": "пейзаж", "en": "landscape"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[3],
                translations: ["ru": "культура", "en": "culture"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[3],
                translations: ["ru": "приключение", "en": "adventure"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),

            // Семья
            WordApiModel(
                categoryId: linkedUUIDs[4],
                translations: ["ru": "родители", "en": "parents"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[4],
                translations: ["ru": "дети", "en": "children"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[4],
                translations: ["ru": "брак", "en": "marriage"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[4],
                translations: ["ru": "любовь", "en": "love"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordApiModel(
                categoryId: linkedUUIDs[4],
                translations: ["ru": "семья", "en": "family"],
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
                translations: ["ru": "программирование", "en": "programming"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordUIModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "разработка", "en": "development"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordUIModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "алгоритм", "en": "algorithm"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordUIModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "система", "en": "system"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            ),
            WordUIModel(
                categoryId: linkedUUIDs[0],
                translations: ["ru": "информатика", "en": "informatics"],
                isLearned: false,
                swipesCounter: 0,
                id: UUID().uuidString
            )
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
