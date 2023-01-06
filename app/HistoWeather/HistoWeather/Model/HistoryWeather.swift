//
//  HistoryWeather.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 27.12.22.
//

import Foundation
 struct HistoricalWeatherDecodable: Decodable {
    let daily: HistoricalDailyDecodable
//    let hourly: HistoricalHourlyDecodable
}

struct HistoricalDailyDecodable: Decodable {
    let time: [String]
    let weathercode: [Int16]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
}

struct HistoricalDailyEntry {
    let time: Date
    let weathericoncode: String
    let temperature_2m_max: Double
    let temperature_2m_min: Double
}

public struct HistoricalGraphDecodable: Decodable {
    let hourly: HistoricalHourlyDecodable
}
struct HistoricalHourlyDecodable: Decodable {
    let time: [Date]
    let temperature_2m: [Double]
    let rain: [Double]
    let windspeed_10m: [Double]
}

struct HistoricalHourlyEntry {
    let time: Date
    let temperature_2m: Double
    let rain: Double
    let windspeed_10m: Double
}
