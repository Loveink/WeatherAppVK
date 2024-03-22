//
//  LabelFactory.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import UIKit

struct LabelFactory {
    static func makeLabel(text: String, fontSize: CGFloat, weight: UIFont.Weight) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor(named: "ColorText")
        label.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
}

