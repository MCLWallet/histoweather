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

	func fetchApi(unit: String, latitude: Double, longitude: Double) async throws {
        try await dayWeatherRepository.loadCurrentWeatherData(tempUnit: unit, latitude: latitude, longitude: longitude)
    }
	
	func getLocationTitle() -> String {
		return dayWeatherRepository.locationTitle
	}
}
