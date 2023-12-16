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
        viewControllers = [catalogVC, profileVC, learningVC]
    }

    private var catalogVC: UIViewController {
        let catalogViewController = UINavigationController(rootViewController: CatalogViewController())
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

    private var profileVC: UIViewController {
        let profileViewController = UINavigationController(
            rootViewController: ProfileViewController(themeViewOutput: ChoosingThemeView(),
                                                      userInformationViewOutput: UserInformationView()
                                                     )
        )
        let title = "Профиль"
        let image = UIImage(systemName: "person.fill")
        profileViewController.tabBarItem = UITabBarItem(title: title, image: image, tag: 2)
        return profileViewController
    }
}
