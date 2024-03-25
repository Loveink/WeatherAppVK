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
  func didStartLoading(_ isLoading: Bool) {
    if isLoading {
      let activityIndicator = UIActivityIndicatorView(style: .large)
      activityIndicator.center = view.center
      activityIndicator.startAnimating()
      view.addSubview(activityIndicator)
    } else {
      view.subviews.filter { $0 is UIActivityIndicatorView }.forEach { $0.removeFromSuperview() }
    }
  }

  func didUpdateCurrent(_ weatherModel: CurrentWeatherModel) {
    weatherView.temperatureLabel.text = "\(weatherModel.tempC)°C"
    weatherView.conditionView.image = UIImage(named: "\(weatherModel.wxIcon)")
    weatherView.windLabel.text = "\(weatherModel.windspdMS) м/с"
    weatherView.fellLikeTemperatureLabel.text = "Ощущается как \(Int(weatherModel.feelslikeC))°C"
  }

  func didUpdateForecast(_ weatherModel: ForecastWeatherModel) {
    weatherView.setup(with: weatherModel)
  }

  func didFailWithError(_ error: Error) {
    let alert = UIAlertController(title: "Ошибка", message: "Что-то пошло не так: \(error.localizedDescription)", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default)
    alert.addAction(okAction)
    self.present(alert, animated: true, completion: nil)
  }
}
