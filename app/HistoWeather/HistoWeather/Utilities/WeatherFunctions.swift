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
