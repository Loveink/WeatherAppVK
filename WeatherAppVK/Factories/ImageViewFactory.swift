//
//  ImageViewFactory.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import UIKit

struct ImageViewFactory {
  static func makeImageView(systemName: String? = nil, imageNamed: String? = nil, contentMode: UIView.ContentMode = .scaleAspectFill, tintColor: UIColor? = nil) -> UIImageView {
    let imageView = UIImageView()
    imageView.contentMode = contentMode
    imageView.isUserInteractionEnabled = true
    imageView.translatesAutoresizingMaskIntoConstraints = false

    if let systemName = systemName {
      imageView.image = UIImage(systemName: systemName)
    }

    if let imageNamed = imageNamed {
      imageView.image = UIImage(named: imageNamed)
    }

    if let tintColor = tintColor {
      imageView.tintColor = tintColor
    }

    return imageView
  }
}
