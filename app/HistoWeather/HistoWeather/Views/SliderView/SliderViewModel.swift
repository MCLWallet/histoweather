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

	func fetchApi() async throws {
		try await dayWeatherRepository.loadHistoricalData()
	}
}

