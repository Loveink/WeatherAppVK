//
//  WeatherViewModel.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import CoreLocation

protocol WeatherViewModelDelegate: AnyObject {
  func didUpdateWeather(_ weatherModel: CurrentWeatherModel)
  func didFailWithError(_ error: Error)
}

class WeatherViewModel: NSObject {
  weak var delegate: WeatherViewModelDelegate?
  private var weatherManager = WeatherManager()
  private let locationManager = CLLocationManager()

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    weatherManager.delegate = self
  }

  func fetchWeather(forCity city: String) {
    weatherManager.fetchWeather(cityName: city)
  }

  func fetchWeatherForCurrentLocation() {
    locationManager.requestLocation()
  }
}

extension WeatherViewModel: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      locations.last
          .map(\.coordinate)
          .map { ($0.latitude, $0.longitude) }
          .map(weatherManager.fetchWeather)
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    didFailWithError(error: error)
  }
}

extension WeatherViewModel: WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: CurrentWeatherModel) {
    delegate?.didUpdateWeather(weather)
  }

  func didFailWithError(error: Error) {
    delegate?.didFailWithError(error)
  }
}
