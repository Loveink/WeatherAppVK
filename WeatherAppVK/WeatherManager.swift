//
//  WeatherManager.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import UIKit
import CoreLocation

protocol WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
  func didFailWithError(error: Error)
}

struct WeatherManager {
  let baseURL = "https://api.openweathermap.org/data/2.5/weather?&units=metric&appid="
  let apiKey = "b076f202ff72f414f67403e0bb36d14e"

  var delegate: WeatherManagerDelegate?

  func fetchWeather(cityName: String) {
    let urlString = "\(baseURL)\(apiKey)&q=\(cityName)"
    performRequest(with: urlString)
  }

  func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let urlString = "\(baseURL)\(apiKey)&lat=\(latitude)&lon=\(longitude)"
    performRequest(with: urlString)
  }

  func performRequest(with urlString: String) {
    if let url = URL(string: urlString) {
      let session = URLSession(configuration: .default)
      let task = session.dataTask(with: url) { (data, response, error) in
        if error != nil {
          self.delegate?.didFailWithError(error: error!)
          return
        }
        if let safeData = data {
          if let weather = self.parseJSON(safeData) {
            self.delegate?.didUpdateWeather(self, weather: weather)
          }
        }
      }
      task.resume()
    }
  }

  func parseJSON(_ weatherData: Data) -> WeatherModel? {
    let decoder = JSONDecoder()
    do {
      let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
      let id = decodedData.weather[0].id
      let temp = decodedData.main.temp
      let name = decodedData.name

      let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
      return weather

    } catch {
      delegate?.didFailWithError(error: error)
      return nil
    }
  }
}

