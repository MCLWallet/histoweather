//
//  TemperatureColorRange.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 04.01.23.
//

import Foundation
import SwiftUI

extension Color {
	static let bordeauxRed = Color("BordeauxRed")
	static let darkBlue = Color("DarkBlue")
	static let justBlue = Color("JustBlue")
	static let lightBlue = Color("LightBlue")
	static let lightYellow = Color("LightYellow")
	static let middleBlue = Color("MiddleBlue")
	static let lightRed = Color("LightRed")
	static let veryLightBlue = Color("VeryLightBlue")
	static let veryLightYellow = Color("VeryLightYellow")
	static let veryRed = Color("VeryRed")
}

enum TemperatureColorRange {
	case veryHot
	case justHot
	case hot
	case warm
	case cool
	case cold
	case freezing

	var gradient: LinearGradient {
		switch self {
		case .veryHot:
			return LinearGradient(
				gradient: Gradient(colors: [.veryRed, .lightYellow]),
				startPoint: .topLeading,
				endPoint: .bottomTrailing)
		case .justHot:
			return LinearGradient(
				gradient: Gradient(colors: [.lightRed, .lightYellow]),
				startPoint: .topLeading,
				endPoint: .bottomTrailing)
		case .hot:
			return LinearGradient(
				gradient: Gradient(colors: [.lightRed, .veryLightYellow]),
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
		case .warm:
			return LinearGradient(
				gradient: Gradient(colors: [.lightYellow, .veryLightYellow]),
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
		case .cool:
			return LinearGradient(
				gradient: Gradient(colors: [.darkBlue, .lightBlue]),
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
		case .cold:
			return LinearGradient(
				gradient: Gradient(colors: [.justBlue, .veryLightBlue]),
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
		case .freezing:
			return LinearGradient(
				gradient: Gradient(colors: [.white, .middleBlue]),
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
		}
	}
}

func convertTemperatureRange(temperatures: [Double], unit: TemperatureUnit) -> [Double] {
	return temperatures.map { temp in
		if unit == .celsius {
			return temp * 1.8 + 32
		} else {
			return (temp - 32) / 1.8
		}
	}
}

func getTemperatureGradient(temperature: Double, unit: TemperatureUnit) -> LinearGradient {
	let celsiusRange: [Double] = [0, 10, 15, 20, 30, 40]
	let fahrenheitRange: [Double] = convertTemperatureRange(temperatures: celsiusRange, unit: .celsius)
	var temperatureRange: [Double] = celsiusRange
	
	if unit == .fahrenheit {
		temperatureRange = fahrenheitRange
	}
	
	if temperature < temperatureRange[0] {
		return TemperatureColorRange.freezing.gradient
	} else if temperature >= temperatureRange[0] && temperature < temperatureRange[1] {
		return TemperatureColorRange.cold.gradient
	} else if temperature >= temperatureRange[1] && temperature < temperatureRange[2] {
		return TemperatureColorRange.cool.gradient
	} else if temperature >= temperatureRange[2] && temperature < temperatureRange[3] {
		return TemperatureColorRange.warm.gradient
	} else if temperature >= temperatureRange[3] && temperature < temperatureRange[4] {
		return TemperatureColorRange.hot.gradient
	} else if temperature >= temperatureRange[4] && temperature < temperatureRange[5] {
		return TemperatureColorRange.justHot.gradient
	} else if temperature >= temperatureRange[5] {
		return TemperatureColorRange.veryHot.gradient
	} else {
		return TemperatureColorRange.cool.gradient
	}
}
