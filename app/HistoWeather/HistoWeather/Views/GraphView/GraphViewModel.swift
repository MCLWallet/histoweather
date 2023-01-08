//
//  GraphViewModel.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 05.01.23.
//

import Foundation
import SwiftUI
import Charts

struct GraphViewModel {

    private let dayWeatherRepository: DayWeatherRepository

    init(dayWeatherRepository: DayWeatherRepository = DayWeatherRepository()) {
        self.dayWeatherRepository = dayWeatherRepository
    }
    
//    func initArray(entries: FetchedResults<HistoricalGraph>) {
//        
//        entries.forEach() { entriy in
//            let lineGraphDataArray = entriy.historicalHourly?.forEach() {
//                object in
//                
//                LineGraphDate(day: <#T##String#>, time: <#T##String#>, temperature: object., windSpeed: <#T##Double#>, rain: <#T##Double#>)
//            }
//        }
//    }

    func fetchApi(tempUnit: String, hourlyParameter: String) async throws {
        try await dayWeatherRepository.loadHistoricalDataHourly(tempUnit: tempUnit, hourlyParameter: hourlyParameter)
    }
	
	func getLocationTitle() -> String {
		return dayWeatherRepository.locationTitle
	}
}
