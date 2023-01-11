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
    @Published var currentTemperatureUnit: TemperatureUnit = TemperatureUnit(rawValue: UserDefaults.standard.string(forKey: "unit") ?? "°C") ?? .celsius
	static let shared = UnitsManager()
	
	override init() {
		super.init()
	}
	
	func changeCurrentTemperatureUnit() {
		if currentTemperatureUnit == .celsius {
                currentTemperatureUnit = .fahrenheit
                UserDefaults.standard.set(currentTemperatureUnit.rawValue, forKey: "unit")
		} else if currentTemperatureUnit == .fahrenheit {
			currentTemperatureUnit = .celsius
            UserDefaults.standard.set(currentTemperatureUnit.rawValue, forKey: "unit")
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
