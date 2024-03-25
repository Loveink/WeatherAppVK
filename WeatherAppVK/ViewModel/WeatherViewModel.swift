//
//  WeatherViewModel.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import CoreLocation

protocol WeatherViewModelDelegate: AnyObject {
  func didStartLoading(_ isLoading: Bool)
  func didFailWithError(_ error: Error)
  func didUpdateCurrent(_ weatherModel: CurrentWeatherModel)
  func didUpdateForecast(_ weatherModel: ForecastWeatherModel)
}

class WeatherViewModel: NSObject {
  weak var delegate: WeatherViewModelDelegate?
  typealias CityCompletion = (String?) -> Void

  private let locationManager = CLLocationManager()
  private let weatherManager: WeatherManager
  private let cityCompleter = CityCompleter()
  private var reverseGeocodeCompletion: CityCompletion?

  init(weatherManager: WeatherManager = .init()) {
    self.weatherManager = weatherManager
    super.init()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
  }

  func fetchWeather(forCity city: String) {
    delegate?.didStartLoading(true)
    let group = DispatchGroup()
    group.enter()

    weatherManager.getCurrentWeather(for: city) { [weak self] result in
      defer { group.leave() }
      guard let self else { return }
      delegate.map { del in
        DispatchQueue.main.async {
          _ = result
            .map(del.didUpdateCurrent)
            .mapError { del.didFailWithError($0); return $0 }
        }
      }
    }

    group.enter()
    weatherManager.getForecastWeather(for: city) { [weak self] result in
      defer { group.leave() }
      guard let self else { return }
      delegate.map { del in
        DispatchQueue.main.async {
          _ = result
            .map(del.didUpdateForecast)
            .mapError { del.didFailWithError($0); return $0 }
        }
      }
    }

    group.notify(queue: .main) {
      self.delegate?.didStartLoading(false)
    }
  }

  func fetchWeatherForCurrentLocation(completion: @escaping CityCompletion) {
    locationManager.requestLocation()
    reverseGeocodeCompletion = completion
  }
}

extension WeatherViewModel: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last {
      let latitude = location.coordinate.latitude
      let longitude = location.coordinate.longitude

      cityCompleter.reverseGeocode(latitude: latitude, longitude: longitude) { [weak self] city in
        DispatchQueue.main.async {
          self?.reverseGeocodeCompletion?(city)
        }
        if let city = city {
          self?.fetchWeather(forCity: city)
        }
      }
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    delegate?.didFailWithError(error)
  }
}
