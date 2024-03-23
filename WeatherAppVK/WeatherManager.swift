//
//  WeatherManager.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: CurrentWeatherModel)
  func didFailWithError(error: Error)
}

struct WeatherManager {
  let currenrBaseURL = "http://api.weatherunlocked.com/api/current/"
  let forecastBaseURL = "http://api.weatherunlocked.com/api/forecast/"
  let apiKey = "6889dd77e925fe59613db86d643f893e"
  let appId = "cddce782"

  let session = URLSession(configuration: .default)
  let decoder = JSONDecoder()
  var delegate: WeatherManagerDelegate?

  func fetchWeather(cityName: String) {
    searchCoordinates(for: cityName) { coordinates in
      if let coordinates = coordinates {
        let urlString = "\(currenrBaseURL)\(coordinates.0),\(coordinates.1)?app_id=\(appId)&app_key=\(apiKey)"
        performRequest(with: urlString)
      } else {
        print("Failed to get coordinates for \(cityName)")
      }
    }
  }

  func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(currenrBaseURL)\(latitude),\(longitude)?app_id=\(appId)&app_key=\(apiKey)"
    performRequest(with: urlString)
  }

  func performRequest(with urlString: String) {
    guard let url = URL(string: urlString) else { return }

    let task = session.dataTask(with: url) { (data, response, error) in
      guard let safeData = data else { self.delegate?.didFailWithError(error: error!)
        return }
      if let weather = self.parseJSON(safeData) {
        self.delegate?.didUpdateWeather(self, weather: weather)
      }
    }
    task.resume()
  }

  func parseJSON(_ weatherData: Data) -> CurrentWeatherModel? {
    do {
      let decodedData = try decoder.decode(CurrentWeatherModel.self, from: weatherData)
      return decodedData
    } catch {
      print("Error decoding JSON: \(error)")
      return nil
    }
  }
}
