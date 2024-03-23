//
//  CurrentWeatherModel.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import Foundation

struct CurrentWeatherModel: Codable {
  let wxIcon: String
  let tempC: Int
  let feelslikeC: Double
  let windspdMS: Double

  enum CodingKeys: String, CodingKey {
    case wxIcon = "wx_icon"
    case tempC = "temp_c"
    case feelslikeC = "feelslike_c"
    case windspdMS = "windspd_ms"
  }
}
