//
//  AddNewWordViewController.swift
//  easyLanguage
//
//  Created by Grigoriy on 07.12.2023.
//
// Всплывающий экран для добавления нового слова

import UIKit

protocol AddNewWordViewOutput {
    func handle(event: AddNewWordViewEvent)
}

protocol AddNewWordOutput: AnyObject {
    func didCreateWord(with categoryId: String)
}

final class AddNewWordViewController: UIViewController {
    var output: AddNewWordViewOutput?

    var categoryId = ""

    let nativeLabel = UILabel()
    let translate = UIImageView()
    let nativeField: UITextField = UITextField()
    let dividingStripView = UIView()
    let foreignLabel = UILabel()
    let foreignField: UITextField = UITextField()
    let button: UIButton = UIButton()
    var horizontalPadding: CGFloat = 0
    var height: CGFloat = 0

    weak var delegate: AddNewWordOutput?
}

// MARK: - life cycle
extension AddNewWordViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        output?.handle(event: .viewLoaded)
    }
}

// MARK: - AddNewWordPresenterOutput
extension AddNewWordViewController: AddNewWordPresenterOutput {
    func handle(event: AddNewWordPresenterEvent) {
        switch event {
        case .showView:
            setAppearance()
            addConstraints()
        case .updateNativeField(text: let text, isNative: let isNative):
            isNative ? (foreignField.text = text) : (nativeField.text = text)
        case .showError(error: let error):
            showAlert(message: error)
        case .updateCategoryDetail(id: let id):
            delegate?.didCreateWord(with: id)

            nativeField.text = nil
            foreignField.text = nil
            self.dismiss(animated: true)
        }
    }
}

// MARK: - Alert
private extension AddNewWordViewController {
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
