//
//  UnitsManager.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 04.01.23.
//

import Foundation

enum TemperatureUnit: String {
	case celsius = "°C"
	case fahrenheit = "°F"
}

class UnitsManager: NSObject, ObservableObject {
	@Published var currentTemperatureUnit: TemperatureUnit = .celsius
	static let shared = UnitsManager()
	
	override init() {
		super.init()
		currentTemperatureUnit = .celsius
	}
	
	func changeCurrentTemperatureUnit() {
		if currentTemperatureUnit == .celsius {
			currentTemperatureUnit = .fahrenheit
		} else if currentTemperatureUnit == .fahrenheit {
			currentTemperatureUnit = .celsius
		}
	}
	
	func getCurrentUnit() -> String {
		if currentTemperatureUnit == .celsius {
			return "celsius"
		} else if currentTemperatureUnit == .fahrenheit {
			return "fahrenheit"
		} else {
			return "unknown"
		}
	}
	
	func getCurrentOppositeUnit() -> String {
		if currentTemperatureUnit == .celsius {
			return "fahrenheit"
		} else if currentTemperatureUnit == .fahrenheit {
			return "celsius"
		} else {
			return "unknown"
		}
	}
}
