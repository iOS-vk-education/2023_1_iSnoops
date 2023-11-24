//
//  CategoryDetailViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 19.11.2023.
//  Экран, попадаем при нажатии на категорию. Отвечает за просмотр категории и добавление новых слов

import UIKit

final class CategoryDetailViewController: CustomViewController {
    var selectedItem: Int?
    private let categoryDetailCollectionView = CategoryDetailCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(categoryDetailCollectionView)
        setCategoryDetailCollectionView()
        title = "title"
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                style: .done,
                                                target: self,
                                                action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

// MARK: - private methods
private extension CategoryDetailViewController {
    @objc
    func addButtonTapped() {
        let presentedController = CategoryDetailBottomSheetViewController()
        if let sheet = presentedController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        present(presentedController, animated: true)
    }

    func setCategoryDetailCollectionView() {
        categoryDetailCollectionView.translatesAutoresizingMaskIntoConstraints = false
        categoryDetailCollectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        categoryDetailCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor,
                                     constant: UIConstants.CategoryDetailCollectionView.padding).isActive = true
        categoryDetailCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor,
                                     constant: -UIConstants.CategoryDetailCollectionView.padding).isActive = true
        categoryDetailCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

// MARK: - Constants
// swiftlint:disable nesting
private extension CategoryDetailViewController {
    struct UIConstants {
        struct CategoryDetailCollectionView {
            static let padding: CGFloat = 18.0
        }
    }
}
// swiftlint:enable nesting
