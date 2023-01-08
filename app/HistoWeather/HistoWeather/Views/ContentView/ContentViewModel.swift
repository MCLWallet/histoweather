//
//  ContentViewModel.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 08.01.23.
//

import Foundation

class ContentViewModel: ObservableObject {

	private let dayWeatherRepository: DayWeatherRepository

	init(dayWeatherRepository: DayWeatherRepository = DayWeatherRepository()) {
		self.dayWeatherRepository = dayWeatherRepository
	}

	func fetchApi(unit: String, latitude: Double, longitude: Double) async throws {
		try await dayWeatherRepository.loadCurrentWeatherData(tempUnit: unit, latitude: latitude, longitude: longitude)
	}
	
	func getLocationTitle() -> String {
		return dayWeatherRepository.locationTitle
	}
}
