//
//  HistoryWeather.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 27.12.22.
//

import Foundation
 struct HistoricalWeatherDecodable: Decodable {
     let daily: HistoricalDailyDecodable
 }

 struct HistoricalDailyDecodable: Decodable {
    let time: [Date]
    let weathercode: [Int16?]
    let temperature_2m_max: [Double?]
    let temperature_2m_min: [Double?]
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
    let time: [String]
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

enum LineGraphParameter: String, CaseIterable, Identifiable {
	case temperature, windSpeed, rain
	var id: Self { self }
}

struct LineGraphDate: Identifiable {
	var id: UUID
	
	var day: String									// represents line
	var time: Date									// x-axis
	var temperature: Double				// y-axis
	var windSpeed: Double					// y-axis
	var rain: Double								// y-axis
	
	init(day: String, time: String, temperature: Double, windSpeed: Double, rain: Double) {
		let timeFormat = DateFormatter()
		timeFormat.dateFormat = "HH:mm"
		
		self.day = day
		self.time = timeFormat.date(from: time)!
		self.temperature = temperature
		self.windSpeed = windSpeed
		self.rain = rain
		self.id = UUID()
	}
}
