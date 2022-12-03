//
//  DayWeatherRepository.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 02.12.22.
//

import Foundation

struct DayWeatherRepository{
    private let dayWeatherPersistence: DayWeatherPersistence

    init(dayWeatherPersistence: DayWeatherPersistence = DayWeatherPersistence()) {
        self.dayWeatherPersistence = dayWeatherPersistence
    }

//    func refreshDayWeather() async throws {
//        let apiItems = try await loadData()
//        try await dayWeatherPersistence.removeAllData()
//        await dayWeatherPersistence.addDayWeatherd(from: apiItems)
//    }


    func loadData() {
        print("loading data")
            guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&daily=sunrise&timezone=Europe%2FBerlin&start_date=2022-12-01&end_date=2022-12-01") else {
                print("Invalid URL")
                return
            }
            let request = URLRequest(url: url)

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let data = data {
                    if let response = try? JSONDecoder().decode(Weather.self, from: data) {
                        DispatchQueue.main.async {
                            Task {
                                        await dayWeatherPersistence.addDayWeather(from: response);
                                 }
                        }
                        return
                    }
                }
            }.resume()
        }
}

public struct Weather: Codable{
    let latitude: Double
    let longitude: Double
}
