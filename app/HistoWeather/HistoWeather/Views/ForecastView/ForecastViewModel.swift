//
//  ContentViewModel.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 02.12.22.
//

struct ForecastViewModel {
    private let dayWeatherRepository: DayWeatherRepository

    init(dayWeatherRepository: DayWeatherRepository = DayWeatherRepository()) {
        self.dayWeatherRepository = dayWeatherRepository
    }

	func fetchApi(unit: String) async throws {
        try await dayWeatherRepository.loadCurrentWeatherData(tempUnit: unit)
    }
}
