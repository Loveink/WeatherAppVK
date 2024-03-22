//
//  ViewController.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
  var viewModel = WeatherViewModel()
  var weatherManager = WeatherManager()
  let locationManager = CLLocationManager()

//MARK: UI elements
  private lazy var conditionView = ImageViewFactory.makeImageView(systemName: "sun.max", tintColor: UIColor(named: "ColorText"))
  private lazy var backgroundView = ImageViewFactory.makeImageView(imageNamed: "background", contentMode: .scaleAspectFill, tintColor: nil)
  private lazy var locationButton = ButtonFactory.makeButton(systemName: "location.circle.fill", action: #selector(locationPressed))
  private lazy var searchButton = ButtonFactory.makeButton(systemName: "magnifyingglass", action: #selector(searchPressed))
  private lazy var searchTextField = TextFieldFactory.makeTextField(withPlaceholder: "Search")
  private lazy var searchStackView = StackViewFactory.makeHorizontalStackView(withSpacing: 10)
  private lazy var temperatureStackView = StackViewFactory.makeHorizontalStackView(withSpacing: 0)
  private lazy var temperatureLabel = LabelFactory.makeLabel(text: "21", fontSize: 80, weight: .bold)
  private lazy var signCelsiusLabel = LabelFactory.makeLabel(text: "°", fontSize: 100, weight: .light)
  private lazy var celsiusLabel = LabelFactory.makeLabel(text: "C", fontSize: 100, weight: .light)
  private lazy var cityLabel = LabelFactory.makeLabel(text: "Moscow", fontSize: 30, weight: .regular)

//MARK: Methods
  override func viewDidLoad() {
    super.viewDidLoad()
    searchTextField.delegate = self
    viewModel.delegate = self
    subviews()
    setupConstraints()
  }

  @objc private func locationPressed(_ sender: UIButton) {
    viewModel.fetchWeatherForCurrentLocation()
  }
}

//MARK: UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {

  @objc func searchPressed(_ sender: UIButton) {
    guard let city = searchTextField.text else { return }
    viewModel.fetchWeather(forCity: city)
    searchTextField.resignFirstResponder()
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchTextField.endEditing(true)
    return true
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.text = ""
  }

  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    if textField.text != "" {
      return true
    } else {
      textField.placeholder = "Type something"
      return false
    }
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if let city = searchTextField.text {
      viewModel.fetchWeather(forCity: city)
    }
    searchTextField.text = ""
  }
}

//MARK: WeatherViewModelDelegate
extension WeatherViewController: WeatherViewModelDelegate {
  func didUpdateWeather(_ weatherModel: WeatherModel) {
    DispatchQueue.main.async {
      self.temperatureLabel.text = weatherModel.temperatureString
      self.conditionView.image = UIImage(systemName: weatherModel.conditionName)
      self.cityLabel.text = weatherModel.cityName
    }
  }

  func didFailWithError(_ error: Error) {
    print("Error \(error.localizedDescription)")
  }
}

extension WeatherViewController {
  private func subviews() {
    view.addSubview(backgroundView)
    backgroundView.addSubview(searchStackView)
    backgroundView.addSubview(conditionView)
    backgroundView.addSubview(temperatureStackView)
    backgroundView.addSubview(cityLabel)
    searchStackView.addArrangedSubview(locationButton)
    searchStackView.addArrangedSubview(searchTextField)
    searchStackView.addArrangedSubview(searchButton)
    temperatureStackView.addArrangedSubview(temperatureLabel)
    temperatureStackView.addArrangedSubview(signCelsiusLabel)
    temperatureStackView.addArrangedSubview(celsiusLabel)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([

      backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
      backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      searchStackView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 20),
      searchStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
      searchStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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

      conditionView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
      conditionView.topAnchor.constraint(equalTo: searchStackView.bottomAnchor, constant: 10),
      conditionView.heightAnchor.constraint(equalToConstant: 120),
      conditionView.widthAnchor.constraint(equalToConstant: 120),

      temperatureStackView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
      temperatureStackView.topAnchor.constraint(equalTo: conditionView.bottomAnchor, constant: 10),
      temperatureLabel.centerYAnchor.constraint(equalTo: celsiusLabel.centerYAnchor),

      cityLabel.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -20),
      cityLabel.topAnchor.constraint(equalTo: temperatureStackView.bottomAnchor, constant: 10)
    ])
  }
}
