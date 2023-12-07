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

        generate()
    }
    private func generate() {
        let viewControllers = [
            generateVC(viewController: UINavigationController(rootViewController: CatalogViewController()),
                       title: Consts.CatalogViewController.tabBarTitle,
                       image: Consts.CatalogViewController.tabBarImage)]
        setViewControllers(viewControllers, animated: true)
    }
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        return viewController
    }

}
// swiftlint:disable nesting
private extension TabBarController {
    struct Consts {
        struct CatalogViewController {
            static let tabBarImage: UIImage = UIImage(systemName: "character.book.closed.fill")!
            static let tabBarTitle = "Слова"
        }

        struct LearningViewController {
            static let tabBarImage: UIImage = UIImage(systemName: "airplane.departure")!
            static let tabBarTitle = "Изучение"
        }

        struct ProfileViewController {
            static let tabBarImage: UIImage = UIImage(systemName: "person.fill")!
            static let tabBarTitle = "Профиль"
        }
    }
}
// swiftlint:enable nesting
