//
//  UserInformationViewDelegate.swift
//  easyLanguage
//
//  Created by Арсений Чистяков on 26.12.2023.
//

import UIKit

final class UserInformationViewController: UIViewController, UserInformationViewDelegate {
        
    private let userInformationView = UserInformationView()
    private let imagePicker = ImagePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userInformationView.delegate = self
    }
    
    @objc func didTapImage() {
        imagePicker.showImagePicker(with: self) { [weak self] image in
                    self?.didSelectImage(image)
                }
    }

    func didSelectImage(_ image: UIImage) {
        imageView.image = image
    }
}
