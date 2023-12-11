//
//  CastomViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 05.11.2023.
//

import UIKit

/// UIViewController в котором прописаны
/// backgroundColor с учетом темы приложения, вью для ошибок, вью(индикатор) загрузки
class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .PrimaryColors.Background.background
    }
}
