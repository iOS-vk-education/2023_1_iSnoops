//
//  ImagePicker.swift
//  easyLanguage
//
//  Created by Grigoriy on 02.12.2023.
//

import UIKit

/// класс для работы открытия галереи и выбора фото

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
        guard let image = info[.originalImage] as? UIImage else {
            print("[ERROR]: Unable to retrieve the image from info dictionary")
            return
        }

        self.completion?(image)
        imagePickerControllerDidCancel(picker)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
