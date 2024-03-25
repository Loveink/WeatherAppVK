//
//  WeatherViewModel.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import CoreLocation

protocol WeatherViewModelDelegate: AnyObject {
  func didUpdateWeather(_ weatherModel: WeatherModel)
  func didFailWithError(_ error: Error)
}

class WeatherViewModel: NSObject {
  weak var delegate: WeatherViewModelDelegate?
  private var weatherManager = WeatherManager()
  private let locationManager = CLLocationManager()
  private var reverseGeocodeCompletion: CityCompletion?
  typealias CityCompletion = (String?) -> Void

  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    weatherManager.delegate = self
  }

  func fetchWeather(forCity city: String) {
    weatherManager.fetchWeather(cityName: city)
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

      reverseGeocode(latitude: latitude, longitude: longitude) { [weak self] city in
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
    didFailWithError(error: error)
  }
}

extension WeatherViewModel: WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
    delegate?.didUpdateWeather(weather)
  }

  func didFailWithError(error: Error) {
    delegate?.didFailWithError(error)
  }
}
