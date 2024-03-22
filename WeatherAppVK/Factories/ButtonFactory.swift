//
//  ButtonFactory.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import UIKit

struct ButtonFactory {
  static func makeButton(systemName: String, action: Selector) -> UIButton {
    let button = UIButton()
    let config = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .default)
    let image = UIImage(systemName: systemName, withConfiguration: config)
    button.setImage(image, for: .normal)
    button.tintColor = UIColor(named: "ColorText")
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: action, for: .touchUpInside)
    return button
  }
}