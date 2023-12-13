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
<<<<<<< Updated upstream
=======
        viewControllers = [catalogVC, learningVC]
    }
>>>>>>> Stashed changes

        view.backgroundColor = .red
    }
    private var learningVC: UIViewController {
        let learningViewController = UINavigationController(rootViewController: LearningViewController())
        let title = "Обучение"
        let image = UIImage(systemName: "character.book.closed.fill")
        learningViewController.tabBarItem = UITabBarItem(title: title, image: image, tag: 1)
        return learningViewController
    }
}
