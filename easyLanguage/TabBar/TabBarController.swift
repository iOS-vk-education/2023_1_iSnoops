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
        viewControllers = [catalogVC]
    }

    private var catalogVC: UIViewController {
        let catalogViewController = UINavigationController(rootViewController: CatalogViewController())
        let title = "Слова"
        let image = UIImage(systemName: "character.book.closed.fill")
        catalogViewController.tabBarItem = UITabBarItem(title: title, image: image, tag: 0)
        return catalogViewController
    }
}
