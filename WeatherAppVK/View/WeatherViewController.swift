//
//  ViewController.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import UIKit
import CoreLocation

final class WeatherViewController: UIViewController {
  var viewModel = WeatherViewModel()
  var weatherManager = WeatherManager()
  let locationManager = CLLocationManager()
  var weatherView = WeatherView()
  var cityCompleter = CityCompleter()

  //MARK: Methods
  override func loadView() {
    view = weatherView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    let searchAction = UIAction { [weak self] _ in
      guard let self else { return }
      weatherView.searchTextField
        .text
        .map(viewModel.fetchWeather(forCity:))
      weatherView.searchTextField.resignFirstResponder()
    }
    let locationAction = UIAction { [weak self] _ in
      self?.viewModel.fetchWeatherForCurrentLocation { city in
        DispatchQueue.main.async {
          self?.weatherView.cityLabel.text = city
        }
      }
    }

    weatherView.searchButton.addAction(searchAction, for: .touchUpInside)
    weatherView.locationButton.addAction(locationAction, for: .touchUpInside)
    weatherView.searchTextField.delegate = self
    viewModel.delegate = self
    viewModel.fetchWeatherForCurrentLocation { [weak self] city in
      DispatchQueue.main.async {
        self?.weatherView.cityLabel.text = city
      }
    }
  }
}

//MARK: UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
  }

  func textFieldDidBeginEditing(_ textField: UITextField) {
    textField.text = ""
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let cityName = textField.text, !cityName.isEmpty else { return }
    cityCompleter.query(cityName) { [weak self] completions in
      guard let completion = completions.first else { return }
      let fullText = completion.title
      DispatchQueue.main.async {
        self?.weatherView.cityLabel.text = fullText
      }
      self?.viewModel.fetchWeather(forCity: fullText)
    }
  }
}

//MARK: WeatherViewModelDelegate
extension WeatherViewController: WeatherViewModelDelegate {
  func didUpdateWeather(_ weatherModel: WeatherModel) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self, let currentWeather = weatherModel.currentWeather, let forecastWeather = weatherModel.forecastWeather else { return }
      self.weatherView.temperatureLabel.text = "\(currentWeather.tempC)°C"
      self.weatherView.conditionView.image = UIImage(named: "\(currentWeather.wxIcon)")
      self.weatherView.windLabel.text = "\(currentWeather.windspdMS) м/с"
      self.weatherView.fellLikeTemperatureLabel.text = "\(Int(currentWeather.feelslikeC))°C"
      self.weatherView.setup(with: forecastWeather)
    }
  }

  func didFailWithError(_ error: Error) {
    print("Error \(error.localizedDescription)")
  }
}
