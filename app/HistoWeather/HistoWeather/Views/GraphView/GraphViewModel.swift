//
//  GraphViewModel.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 05.01.23.
//

import Foundation
import SwiftUI
import Charts
import CoreLocation

struct GraphViewModel {

    private let dayWeatherRepository: DayWeatherRepository

    init(dayWeatherRepository: DayWeatherRepository = DayWeatherRepository()) {
        self.dayWeatherRepository = dayWeatherRepository
    }

	func fetchApi(tempUnit: String, startDate: Date, endDate: Date) async throws {
        try await dayWeatherRepository.loadHistoricalDataHourly(tempUnit: tempUnit, startDate: startDate, endDate: endDate)
    }
	
	func setLocation(location: CLLocation) {
		dayWeatherRepository.updateLocation(location: location)
	}
	
	func getLocationTitle() -> String {
		return dayWeatherRepository.locationTitle
	}
}
