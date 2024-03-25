//
//  WeatherManager.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
  func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
  func didFailWithError(error: Error)
}

struct WeatherManager {
  let session = URLSession(configuration: .default)
  let decoder = JSONDecoder()
  var delegate: WeatherManagerDelegate?
  let cityCompleter = CityCompleter()

  func getForecastWeather(for cityName: String, _ completion: @escaping (Result<ForecastWeatherModel, Error>) -> Void) {
    cityCompleter.searchCoordinates(for: cityName) { coordinates in
      switch coordinates {
      case let .some((lat, lon)):
        getForecastWeather(lat: lat, lon: lon, completion)

      case .none:
        completion(.failure(CLLocationPushServiceError(.unknown)))
      }
    }
  }

  func getForecastWeather(lat: Double, lon: Double, _ completion: @escaping (Result<ForecastWeatherModel, Error>) -> Void) {
    getWeather(.forecastWeatherAt(latitude: lat, longitude: lon), completion: completion)
  }

  func getCurrentWeather(for cityName: String, _ completion: @escaping (Result<CurrentWeatherModel, Error>) -> Void) {
    cityCompleter.searchCoordinates(for: cityName) { coordinates in
      switch coordinates {
      case let .some((lat, lon)):
        getCurrentWeather(lat: lat, lon: lon, completion)

      case .none:
        completion(.failure(CLLocationPushServiceError(.unknown)))
      }
    }
  }

  func getCurrentWeather(lat: Double, lon: Double, _ completion: @escaping (Result<CurrentWeatherModel, Error>) -> Void) {
    getWeather(.currentWeatherAt(latitude: lat, longitude: lon), completion: completion)
  }

  func getWeather<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) {
    request(from: endpoint.url) { result in
      completion(
        result
          .decode(T.self, decoder: self.decoder)
      )
    }
  }

  func request(from url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
    session.dataTask(with: url) { data, response, error in
      error
        .map(Result.failure)
        .map(completion)

      response
        .flatMap { $0 as? HTTPURLResponse }
        .map(\.statusCode)
        .flatMap { (200...299).contains($0) ? nil : $0 }
        .map { _ in URLError(.badServerResponse) }
        .map(Result.failure)
        .map(completion)

      data.map(Result.success)
        .map(completion)
    }
    .resume()
  }
}

extension Result where Success == Data, Failure == Error {
  @inlinable
  func decode<T:Decodable>(_ type: T.Type, decoder: JSONDecoder) -> Result<T, Failure> {
    switch self {
    case .success(let data):
      return Result<T, Failure> { try decoder.decode(type, from: data) }

    case .failure(let failure):
      return .failure(failure)
    }
  }
}
