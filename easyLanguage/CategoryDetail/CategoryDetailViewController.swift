//
//  CategoryDetailViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 19.11.2023.
//  Экран, попадаем при нажатии на категорию. Отвечает за просмотр категории и добавление новых слов

import UIKit

final class CategoryDetailViewController: UIViewController {
    var selectedItem: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        let textColor: UIColor

        switch (selectedItem ?? 0) % 8 {
        case 0:
            view.backgroundColor = .Catalog.Green.categoryBackground
            textColor = .Catalog.Green.categoryText
        case 1:
            view.backgroundColor = .Catalog.Purple.categoryBackground
            textColor = .Catalog.Purple.categoryText
        case 2:
            view.backgroundColor = .Catalog.LightYellow.categoryBackground
            textColor = .Catalog.LightYellow.categoryText
        case 3:
            view.backgroundColor = .Catalog.Yellow.categoryBackground
            textColor = .Catalog.Yellow.categoryText
        case 4:
            view.backgroundColor = .Catalog.Red.categoryBackground
            textColor = .Catalog.Red.categoryText
        case 5:
            view.backgroundColor = .Catalog.Blue.categoryBackground
            textColor = .Catalog.Blue.categoryText
        case 6:
            view.backgroundColor = .Catalog.Cyan.categoryBackground
            textColor = .Catalog.Cyan.categoryText
        default:
            view.backgroundColor = .Catalog.Pink.categoryBackground
            textColor = .Catalog.Pink.categoryText
        }
    }
}
