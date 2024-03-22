//
//  TextFieldFactory.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import UIKit

struct TextFieldFactory {
    static func makeTextField(withPlaceholder placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.font = UIFont.systemFont(ofSize: 25, weight: .regular)
        textField.textColor = .lightGray
        textField.textAlignment = .right
        textField.autocapitalizationType = .words
        textField.returnKeyType = .go
        textField.backgroundColor = .placeholderText
        textField.layer.cornerRadius = 5
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
}
