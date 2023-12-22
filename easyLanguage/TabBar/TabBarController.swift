//
//  TabBarController.swift
//  easyLanguage
//
//  Created by Grigoriy on 24.10.2023.
//
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [catalogVC, learningVC]
    }

    private var catalogVC: UIViewController {
        let presenter = CatalogPresenter()
        let viewController = CatalogViewController(output: presenter)
        presenter.view = viewController
        let catalogViewController = UINavigationController(rootViewController: viewController)
        let title = "Слова"
        let image = UIImage(systemName: "character.book.closed.fill")
        catalogViewController.tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
        return catalogViewController
    }

    private var learningVC: UIViewController {
        let learningViewController = UINavigationController(rootViewController: LearningViewController())
        let title = "Тренировка слов"
        let image = UIImage(systemName: "character.book.closed.fill")
        learningViewController.tabBarItem = UITabBarItem(title: title, image: image, tag: 1)
        return learningViewController
    }
}
