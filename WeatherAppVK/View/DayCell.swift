//
//  DayCell.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 23.03.2024.
//

import UIKit

class DayCell: UICollectionViewCell {

  static let identifier = "CategoryCell"

  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .white
    layer.cornerRadius = 20
    layer.masksToBounds = true
    layer.borderColor = UIColor.systemBlue.cgColor
    layer.borderWidth = 5
    setupViews()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  //MARK: - Outlets
  let dateLabel = LabelFactory.makeLabel(text: "21.04", fontSize: 20, weight: .bold)
  let conditionView = ImageViewFactory.makeImageView(systemName: "sun.max", tintColor: UIColor(named: "ColorText"))
  let minTemperatureLabel = LabelFactory.makeLabel(text: "-6°", fontSize: 20, weight: .bold)
  let maxTemperatureLabel = LabelFactory.makeLabel(text: "21°", fontSize: 20, weight: .bold)
  private let windView = ImageViewFactory.makeImageView(systemName: "wind", tintColor: UIColor(named: "ColorText"))
  private let windLabel = LabelFactory.makeLabel(text: "21 ms", fontSize: 20, weight: .bold)

  //MARK: - Functions

  public func configureCell(_ data: ForecastWeatherModel) {
    DispatchQueue.main.async {
      guard let firstDay = data.days.first else { return }

      let tempMaxC = firstDay.tempMaxC
      let tempMinC = firstDay.tempMinC
      let fourthDay = data.days[3]
      let fourthTimeframe = fourthDay.timeframes[3]

      self.dateLabel.text = firstDay.date
      self.minTemperatureLabel.text = "\(tempMinC)°"
      self.maxTemperatureLabel.text = "\(tempMaxC)°"
      self.windLabel.text = "\(fourthTimeframe.windspdMS) ms"
      self.conditionView.image = UIImage(named: fourthTimeframe.wxIcon)
    }
  }

  private func setupViews() {
    contentView.addSubview(dateLabel)
    contentView.addSubview(conditionView)
    contentView.addSubview(minTemperatureLabel)
    contentView.addSubview(maxTemperatureLabel)
    contentView.addSubview(windView)
    contentView.addSubview(windLabel)
  }

  //MARK: - Constraints
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

      conditionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      conditionView.leadingAnchor.constraint(equalTo: dateLabel.trailingAnchor, constant: 40),
      conditionView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),

      maxTemperatureLabel.leadingAnchor.constraint(equalTo: conditionView.trailingAnchor, constant: 20),
      maxTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      maxTemperatureLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),

      minTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      minTemperatureLabel.leadingAnchor.constraint(equalTo: maxTemperatureLabel.trailingAnchor, constant: 20),
      minTemperatureLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),

      windView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      windView.trailingAnchor.constraint(equalTo: windLabel.leadingAnchor, constant: -10),
      windView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -20),

      windLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      windLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
      windLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10)
    ])
  }
}

#Preview {
  DayCell()
}
