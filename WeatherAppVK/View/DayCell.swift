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
  let separatorLabel = LabelFactory.makeLabel(text: "|", fontSize: 20, weight: .bold)

  //MARK: - Functions
  public func configureCell(_ day: Day) {
    let dateString = day.date
      let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
      dateFormatter.dateFormat = "dd/MM/yyyy"
      guard let date = dateFormatter.date(from: dateString) else {
          print("Ошибка преобразования даты")
          return
      }

    let tempMaxC = day.tempMaxC
    let tempMinC = day.tempMinC

    dateFormatter.dateFormat = "dd MMMM"
       let formattedDate = dateFormatter.string(from: date)
       self.dateLabel.text = formattedDate

    self.minTemperatureLabel.text = "\(Int(tempMinC))°"
    self.maxTemperatureLabel.text = "\(Int(tempMaxC))°"
    if day.timeframes.count > 3 {
      let fourthTimeframe = day.timeframes[3]
      self.conditionView.image = UIImage(named: fourthTimeframe.wxIcon)
    } else {
      let fourthTimeframe = day.timeframes[0]
      self.conditionView.image = UIImage(named: fourthTimeframe.wxIcon)
    }
  }

  private func setupViews() {
    contentView.addSubview(dateLabel)
    contentView.addSubview(conditionView)
    contentView.addSubview(minTemperatureLabel)
    contentView.addSubview(maxTemperatureLabel)
    contentView.addSubview(separatorLabel)
  }

  //MARK: - Constraints
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      dateLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

      conditionView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      conditionView.centerXAnchor.constraint(equalTo: centerXAnchor),
      conditionView.heightAnchor.constraint(equalTo: heightAnchor),
      conditionView.widthAnchor.constraint(equalTo: heightAnchor),

      maxTemperatureLabel.trailingAnchor.constraint(equalTo: separatorLabel.leadingAnchor, constant: -20),
      maxTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      maxTemperatureLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10),

      separatorLabel.trailingAnchor.constraint(equalTo: minTemperatureLabel.leadingAnchor, constant: -20),
      separatorLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      separatorLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor),

      minTemperatureLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      minTemperatureLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      minTemperatureLabel.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -10)
    ])
  }
}
