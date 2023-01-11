//
//  CurrentWeather.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 27.12.22.
//

import Foundation

// Only used for decoding
struct Weather: Decodable {
	let daily: Daily
	let elevation: Double
	let latitude: Double
	let longitude: Double
	let current_weather: CurrentWeather
}

struct CurrentWeather: Decodable {
	let time: Date
	let temperature: Double
	let windspeed: Double
	let winddirection: Double
	let weathercode: Int16
}

struct Daily: Decodable {
	let time: [String]
	let weathercode: [Int16]
	let temperature_2m_max: [Double]
	let temperature_2m_min: [Double]
	let sunrise: [Date]
	let sunset: [Date]
	let precipitation_sum: [Double]
	let windspeed_10m_max: [Double]
}

struct DayEntry {
	let time: Date
	let weathericoncode: String
	let temperature_2m_max: Double
	let temperature_2m_min: Double
	let sunrise: Date
	let sunset: Date
	let precipitation_sum: Double
	let windspeed_10m_max: Double
}
