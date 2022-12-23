//
//  CurrentViewModel.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 02.12.22.
//

import Foundation

struct CurrentViewModel {

    private let dayWeatherRepository: DayWeatherRepository

    init(dayWeatherRepository: DayWeatherRepository = DayWeatherRepository()) {
        self.dayWeatherRepository = dayWeatherRepository
    }

    func fetchApi() async throws {
        try await dayWeatherRepository.loadCurrentWeatherData()
    }
}
