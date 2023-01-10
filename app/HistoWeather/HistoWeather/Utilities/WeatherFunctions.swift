//
//  WeatherFunctions.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 27.12.22.
//

import Foundation

func weatherCodeToIcon(weatherCode: Int16) -> String {
	if weatherCode == 0 {
		return "sun.max"
	} else if weatherCode == 1 || weatherCode == 2 || weatherCode == 3 {
		return "cloud.sun"
	} else if weatherCode == 45 || weatherCode == 48 {
		return "cloud.fog"
	} else if weatherCode == 51 || weatherCode == 53 || weatherCode == 55 {
		return "cloud.drizzle"
	} else if weatherCode == 56 || weatherCode == 57 {
		return "cloud.drizzle"
	} else if weatherCode == 61 || weatherCode == 63 || weatherCode == 65 {
		return "cloud.rain"
	} else if weatherCode == 66 || weatherCode == 67 {
		return "cloud.sleet"
	} else if weatherCode == 71 || weatherCode == 73 || weatherCode == 75 {
		return "snowflake"
	} else if weatherCode == 77 {
		return "cloud.snow"
	} else if weatherCode == 80 || weatherCode == 81 || weatherCode == 82 {
		return "cloud.heavyrain"
	} else if weatherCode == 85 || weatherCode == 86 {
		return "cloud.snow"
	} else if weatherCode == 95 {
		return "cloud.bolt"
	} else if weatherCode == 96 || weatherCode == 99 {
		return "cloud.bolt.rain"
	} else {
		return "wrench.fill"
	}
}

func convertDate(date: String, format: String) -> Date {
	if format == "yyyy-MM-dd'T'HH:mm" {
		let dateFormatter = ISO8601DateFormatter()
		dateFormatter.formatOptions = [
			.withFullDate,
			.withDashSeparatorInDate,
			.withColonSeparatorInTime
		]
		return dateFormatter.date(from: date)!
	} else {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.locale = .current
		dateFormatter.timeZone = .current
		return dateFormatter.date(from: date)!
	}
}

func getSameDayWithDifferentYear(newYear: Double) -> Date {
	let calendar = Calendar.current
	let currentDate = Date()

	// Get the month and day of the current date
	let currentMonth = calendar.component(.month, from: currentDate)
	let currentDay = calendar.component(.day, from: currentDate)

	// Create a new DateComponents object with the same month and day but a different year
	let newDateComponents = DateComponents(calendar: calendar, year: Int(newYear), month: currentMonth, day: currentDay)

	// Create a new Date object from the DateComponents object
	let newDate = calendar.date(from: newDateComponents)

	return newDate ?? Date()
}
