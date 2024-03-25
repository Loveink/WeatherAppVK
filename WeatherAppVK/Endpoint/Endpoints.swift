//
//  Endpoints.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 25.03.2024.
//

import Foundation

// "http://api.weatherunlocked.com/api/current/55.7586642,37.6192919?app_id=cddce782&app_key=6889dd77e925fe59613db86d643f893e"
// "http://api.weatherunlocked.com/api/forecast/55.7586642,37.6192919?app_id=cddce782&app_key=6889dd77e925fe59613db86d643f893e"

extension Endpoint {
  @inlinable
  func appendingKeys() -> Self {
    self.addQueryItem(URLQueryItem(name: "app_id", value: "cddce782"))
      .addQueryItem(URLQueryItem(name: "app_key", value: "6889dd77e925fe59613db86d643f893e"))
  }

  @inlinable
  static func currentWeather() -> Endpoint {
    Endpoint(path: "current/")
  }

  @inlinable
  static func forecastWeather() -> Endpoint {
    Endpoint(path: "forecast/")
  }

  @inlinable
  static func currentWeatherAt(latitude: Double, longitude: Double) -> Endpoint {
    Endpoint
      .currentWeather()
      .appendPath([latitude, longitude].map(\.description).joined(separator: ","))
      .appendingKeys()
  }

  @inlinable
  static func forecastWeatherAt(latitude: Double, longitude: Double) -> Endpoint {
    Endpoint
      .forecastWeather()
      .appendPath([latitude, longitude].map(\.description).joined(separator: ","))
      .appendingKeys()
  }
}
