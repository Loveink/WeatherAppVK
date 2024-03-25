//
//  CurrentWeatherModel.swift
//  WeatherAppVK
//
//  Created by Александра Савчук on 22.03.2024.
//

import Foundation

struct WeatherModel: Codable {
  let currentWeather: CurrentWeatherModel?
  let forecastWeather: ForecastWeatherModel?
}

//MARK: CurrentWeatherModel
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

//MARK: ForecastWeatherModel
struct ForecastWeatherModel: Codable {
  let days: [Day]

  enum CodingKeys: String, CodingKey {
    case days = "Days"
  }
}

struct Day: Codable {
  let date: String
  let tempMaxC: Double
  let tempMinC: Double
  let precipTotalIn: Double
  let windspdMaxMS: Double
  let slpMinMB: Double
  let timeframes: [Timeframe]

  enum CodingKeys: String, CodingKey {
    case date
    case tempMaxC = "temp_max_c"
    case tempMinC = "temp_min_c"
    case precipTotalIn = "precip_total_in"
    case windspdMaxMS = "windspd_max_ms"
    case slpMinMB = "slp_min_mb"
    case timeframes = "Timeframes"
  }
}

struct Timeframe: Codable {
  let date: String
  let time: Int
  let wxDesc: String
  let wxIcon: String
  let tempC: Double
  let feelslikeC: Double
  let windspdMS: Double
  let slpIn: Double

  enum CodingKeys: String, CodingKey {
    case date, time
    case wxDesc = "wx_desc"
    case wxIcon = "wx_icon"
    case tempC = "temp_c"
    case feelslikeC = "feelslike_c"
    case windspdMS = "windspd_ms"
    case slpIn = "slp_in"
  }
}
