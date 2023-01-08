//
//  SliderViewModel.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 23.12.22.
//

import Foundation

struct SliderViewModel {
	private let dayWeatherRepository: DayWeatherRepository

	init(dayWeatherRepository: DayWeatherRepository = DayWeatherRepository()) {
		self.dayWeatherRepository = dayWeatherRepository
	}

	func fetchApi(unit: String, startYear: Int, endYear: Int) async throws {
		try await dayWeatherRepository.loadHistoricalData(tempUnit: unit, startYear: startYear, endYear: endYear)
	}
}
