//
//  ForecastViewModel.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 02.12.22.
//
import CoreLocation

struct ForecastViewModel {
    private let dayWeatherRepository: DayWeatherRepository

    init(dayWeatherRepository: DayWeatherRepository = DayWeatherRepository()) {
        self.dayWeatherRepository = dayWeatherRepository
    }

	func fetchApi(unit: String) async throws {
        try await dayWeatherRepository.loadCurrentWeatherData(tempUnit: unit)
    }
	
	func setLocation(location: CLLocation) {
		dayWeatherRepository.updateLocation(location: location)
	}
	
	func getLocationTitle() -> String {
		return dayWeatherRepository.locationTitle
	}
}
