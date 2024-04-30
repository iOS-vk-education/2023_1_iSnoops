//
//  AddWordVC + Constraints.swift
//  easyLanguage
//
//  Created by Grigoriy on 16.04.2024.
//

import UIKit

extension AddWordViewController {
    func setConstraints() {
        [nativeLabel, translate, foreignLabel, nativeField, foreignField, addWordButton, dividerView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        nativeL()
        translateI()
        nativeF()
        dividerV()
        foreignL()
        foreignF()
        addButtonC()
    }

    private func nativeL() {
        nativeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: height).isActive = true
        nativeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        nativeLabel.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.5).isActive = true
        nativeLabel.sizeToFit()
    }

    private func nativeF() {
        nativeField.topAnchor.constraint(equalTo: nativeLabel.bottomAnchor, constant: UIConstants.top).isActive = true
        nativeField.heightAnchor.constraint(equalToConstant: height).isActive = true
        nativeField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        nativeField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
    }

    private func translateI() {
        translate.bottomAnchor.constraint(equalTo: nativeField.topAnchor, constant: -UIConstants.top).isActive = true
        translate.widthAnchor.constraint(equalToConstant: height).isActive = true
        translate.heightAnchor.constraint(equalToConstant: height).isActive = true
        translate.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
    }

    private func dividerV() {
        dividerView.topAnchor.constraint(equalTo: nativeField.bottomAnchor, constant: 30).isActive = true
        dividerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        dividerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }

    private func foreignL() {
        foreignLabel.topAnchor.constraint(equalTo: dividerView.bottomAnchor, constant: UIConstants.top).isActive = true
        foreignLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        foreignLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        foreignLabel.sizeToFit()
    }

    private func foreignF() {
        foreignField.topAnchor.constraint(equalTo: foreignLabel.bottomAnchor, constant: UIConstants.top).isActive = true
        foreignField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        foreignField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        foreignField.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    private func addButtonC() {
        addWordButton.topAnchor.constraint(equalTo: foreignField.bottomAnchor, constant: 15).isActive = true
        addWordButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding).isActive = true
        addWordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding).isActive = true
        addWordButton.heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    private struct UIConstants {
        static let top: CGFloat = 10
    }
}
