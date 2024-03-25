//
//  WeatherView.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 23.03.2024.
//

import UIKit

final class WeatherView: UIView {
  //MARK: Public properties
  let conditionView = ImageViewFactory.makeImageView(systemName: "sun.max", tintColor: UIColor(named: "ColorText"))
  let searchTextField = TextFieldFactory.makeTextField(withPlaceholder: "Search")
  let temperatureLabel = LabelFactory.makeLabel(text: "21°C", fontSize: 80, weight: .bold)
  let cityLabel = LabelFactory.makeLabel(text: "Moscow", fontSize: 30, weight: .regular)
  let locationButton = ButtonFactory.makeButton(systemName: "location.circle.fill")
  let searchButton = ButtonFactory.makeButton(systemName: "magnifyingglass")
  let windLabel = LabelFactory.makeLabel(text: "21 ms", fontSize: 20, weight: .bold)
  let fellLikeTemperatureLabel = LabelFactory.makeLabel(text: "10°C", fontSize: 20, weight: .bold)
  let collection7days = DayCollectionView()

  //MARK: Private properties
  private let windView = ImageViewFactory.makeImageView(systemName: "wind", tintColor: UIColor(named: "ColorText"))
  private lazy var backgroundView = ImageViewFactory.makeImageView(imageNamed: "background", contentMode: .scaleAspectFill, tintColor: nil)
  private let searchStackView = StackViewFactory.makeHorizontalStackView()
  private let fellLikeLabel = LabelFactory.makeLabel(text: "Ощущается как", fontSize: 20, weight: .bold)

  override init(frame: CGRect) {
    super.init(frame: frame)

    subviews()
    setupConstraints()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setup(with forecastWeather: ForecastWeatherModel) {
    collection7days.forecastWeather = forecastWeather
  }
}

private extension WeatherView {
  func subviews() {
    collection7days.translatesAutoresizingMaskIntoConstraints = false

    addSubview(backgroundView)
    backgroundView.addSubview(searchStackView)
    backgroundView.addSubview(cityLabel)

    searchStackView.addArrangedSubview(locationButton)
    searchStackView.addArrangedSubview(searchTextField)
    searchStackView.addArrangedSubview(searchButton)

    backgroundView.addSubview(conditionView)
    backgroundView.addSubview(temperatureLabel)
    backgroundView.addSubview(fellLikeLabel)
    backgroundView.addSubview(fellLikeTemperatureLabel)
    backgroundView.addSubview(windView)
    backgroundView.addSubview(windLabel)
    backgroundView.addSubview(collection7days)
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      backgroundView.topAnchor.constraint(equalTo: topAnchor),
      backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),

      searchStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
      searchStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
      searchStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      searchStackView.bottomAnchor.constraint(equalTo: searchButton.bottomAnchor),

      locationButton.leadingAnchor.constraint(equalTo: searchStackView.leadingAnchor),
      locationButton.topAnchor.constraint(equalTo: searchStackView.topAnchor),
      locationButton.heightAnchor.constraint(equalToConstant: 40),
      locationButton.widthAnchor.constraint(equalToConstant: 40),

      searchTextField.leadingAnchor.constraint(equalTo: locationButton.trailingAnchor, constant: 10),

      searchButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 10),
      searchButton.trailingAnchor.constraint(equalTo: searchStackView.trailingAnchor),
      searchButton.topAnchor.constraint(equalTo: searchStackView.topAnchor),
      searchButton.heightAnchor.constraint(equalToConstant: 40),
      searchButton.widthAnchor.constraint(equalToConstant: 40),

      conditionView.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 5),
      conditionView.leadingAnchor.constraint(equalTo: locationButton.leadingAnchor),
      conditionView.heightAnchor.constraint(equalToConstant: 120),
      conditionView.widthAnchor.constraint(equalToConstant: 120),

      temperatureLabel.centerYAnchor.constraint(equalTo: conditionView.centerYAnchor),
      temperatureLabel.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor),

      fellLikeLabel.leadingAnchor.constraint(equalTo: temperatureLabel.leadingAnchor),
      fellLikeLabel.bottomAnchor.constraint(equalTo: windLabel.topAnchor),

      fellLikeTemperatureLabel.leadingAnchor.constraint(equalTo: fellLikeLabel.trailingAnchor, constant: 5),
      fellLikeTemperatureLabel.bottomAnchor.constraint(equalTo: windLabel.topAnchor),

      cityLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
      cityLabel.topAnchor.constraint(equalTo: conditionView.bottomAnchor, constant: 10),

      windView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
      windView.topAnchor.constraint(equalTo: conditionView.bottomAnchor, constant: 10),

      windLabel.leadingAnchor.constraint(equalTo: windView.trailingAnchor, constant: 20),
      windLabel.topAnchor.constraint(equalTo: conditionView.bottomAnchor, constant: 10),

      collection7days.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
      collection7days.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
      collection7days.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
      collection7days.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10)
    ])
  }
}
