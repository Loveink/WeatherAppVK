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
  let currentBaseURL = "http://api.weatherunlocked.com/api/current/"
  let forecastBaseURL = "http://api.weatherunlocked.com/api/forecast/"
  let apiKey = "6889dd77e925fe59613db86d643f893e"
  let appId = "cddce782"

  let session = URLSession(configuration: .default)
  let decoder = JSONDecoder()
  var delegate: WeatherManagerDelegate?

  func fetchWeather(cityName: String) {
    searchCoordinates(for: cityName) { coordinates in
      if let coordinates = coordinates {
        let currentURLString = "\(self.currentBaseURL)\(coordinates.0),\(coordinates.1)?app_id=\(self.appId)&app_key=\(self.apiKey)"
        let forecastURLString = "\(self.forecastBaseURL)\(coordinates.0),\(coordinates.1)?app_id=\(self.appId)&app_key=\(self.apiKey)"
        self.performRequest(with: currentURLString, forecastURLString)
      } else {
        print("Failed to get coordinates for \(cityName)")
      }
    }
  }

  func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
    let currentURLString = "\(self.currentBaseURL)\(latitude),\(longitude)?app_id=\(self.appId)&app_key=\(self.apiKey)"
    let forecastURLString = "\(self.forecastBaseURL)\(latitude),\(longitude)?app_id=\(self.appId)&app_key=\(self.apiKey)"
    self.performRequest(with: currentURLString, forecastURLString)
  }

  func performRequest(with currentURLString: String, _ forecastURLString: String) {
    guard let currentURL = URL(string: currentURLString), let forecastURL = URL(string: forecastURLString) else { return }

    let group = DispatchGroup()
    var currentWeather: CurrentWeatherModel?
    var forecastWeather: ForecastWeatherModel?

    group.enter()
    let currentTask = session.dataTask(with: currentURL) { (data, response, error) in
      defer { group.leave() }
      guard let data = data else { return }
      currentWeather = self.parseCurrentJSON(data)
    }
    currentTask.resume()

    group.enter()
    let forecastTask = session.dataTask(with: forecastURL) { (data, response, error) in
      defer { group.leave() }
      guard let data = data else { return }
      forecastWeather = self.parseForecastJSON(data)
    }
    forecastTask.resume()

    group.notify(queue: .main) {
      let weather = WeatherModel(currentWeather: currentWeather, forecastWeather: forecastWeather)
      self.delegate?.didUpdateWeather(self, weather: weather)
    }
  }

  func parseCurrentJSON(_ data: Data) -> CurrentWeatherModel? {
    do {
      let decodedData = try decoder.decode(CurrentWeatherModel.self, from: data)
      return decodedData
    } catch {
      print("Error decoding current weather JSON: \(error)")
      return nil
    }
  }

  func parseForecastJSON(_ data: Data) -> ForecastWeatherModel? {
    do {
      let decodedData = try decoder.decode(ForecastWeatherModel.self, from: data)
      return decodedData
    } catch {
      print("Error decoding forecast weather JSON: \(error)")
      return nil
    }
  }
}
