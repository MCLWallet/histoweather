//
//  HistoryWeather.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 27.12.22.
//

import Foundation

struct HistoricalWeather: Decodable {
	let daily: HistoricalDaily
}

struct HistoricalDaily: Decodable {
	let time: [String]
	let weathercode: [Int16]
	let temperature_2m_max: [Double]
	let temperature_2m_min: [Double]
}
