//
//  BottomSheetViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 04.12.2023.
//  BottomSheetViewController с заранее заданой созданной visualBar (вьюха сверху)

import UIKit

class BottomSheetViewController: CustomViewController {
    let visualBar = UIView() // убрал private, тк считаем относительно него высоту

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(visualBar)
        setVisualAppearance()
        setVisualBar()
    }
}

// MARK: - private methods
private extension BottomSheetViewController {
    func setVisualAppearance() {
        visualBar.layer.cornerRadius = Consts.VisualBar.cornerRadius
        visualBar.backgroundColor = .red // FIXME: занести нужный цвет
    }

    func setVisualBar() {
        visualBar.translatesAutoresizingMaskIntoConstraints = false
        visualBar.topAnchor.constraint(equalTo: view.topAnchor,
                                       constant: UIConstants.VisualBar.top).isActive = true
        visualBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        visualBar.widthAnchor.constraint(equalToConstant: view.frame.width / 8).isActive = true
        visualBar.heightAnchor.constraint(equalToConstant: UIConstants.VisualBar.height).isActive = true
    }
}

// MARK: - Consts
// swiftlint:disable nesting
private extension BottomSheetViewController {
    struct Consts {
        struct VisualBar {
            static let cornerRadius: CGFloat = 4
        }
    }

    struct UIConstants {
        struct VisualBar {
            static let top: CGFloat = 10.0
            static let height: CGFloat = 8.0
        }
    }
}
// swiftlint:enable nesting
