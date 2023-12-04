//
//  ImagePicker.swift
//  easyLanguage
//
//  Created by Grigoriy on 02.12.2023.
//

import UIKit

/// класс для работы откртия галереи и выбора фото
/// пример использования:
///    private let imagePicker = ImagePicker()
///
///    imagePicker.showImagePicker(with: self) { [weak self] image in
///       self?.didSelectImage(image)
///    }
///
///    // Метод, который будет вызван после выбора изображения
///     private func didSelectImage(_ image: UIImage) {
///     }

final class ImagePicker: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    var completion: ((UIImage) -> Void)?

    func showImagePicker(with viewController: UIViewController, completion: ((UIImage) -> Void)?) {
        self.completion = completion
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        viewController.present(imagePickerController, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.completion?(image)
            picker.dismiss(animated: true)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
