//
//  HistoryWeather.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 27.12.22.
//

import Foundation
public struct HistoricalWeatherDecodable: Decodable {
    let daily: HistoricalDailyDecodable
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
