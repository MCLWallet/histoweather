//
//  DayWeatherRepository.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 02.12.22.
//

import Foundation

struct DayWeatherRepository {
    private let dayWeatherPersistence: DayWeatherPersistence
    
    init(dayWeatherPersistence: DayWeatherPersistence = DayWeatherPersistence()) {
        self.dayWeatherPersistence = dayWeatherPersistence
    }


    func loadData() async throws{
        try await dayWeatherPersistence.removeAllFriends()
        
        guard let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&daily=weathercode,temperature_2m_max,temperature_2m_min,sunrise,sunset,precipitation_sum,windspeed_10m_max&current_weather=true&timezone=Europe%2FBerlin") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd'T'HH:mm"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
               URLSession.shared.dataTask(with: request) { data, response, error in
                   if let data = data {
                       if let response = try? decoder.decode(Weather.self, from: data) {
                           DispatchQueue.main.async {
                        Task{
                            await dayWeatherPersistence.addDayWeather(from: response)
                            print("\(response.elevation)")
                        }
                    }
                    return
                }
            }
        }.resume()
    }
}

public struct Weather: Decodable {
    
    let daily: Daily
    let elevation: Double
    let current_weather: CurrentWeather
    
}
struct CurrentWeather: Decodable {
    let time: Date
    let temperature: Double
    let windspeed: Double
    let winddirection: Double
    let weathercode: Int16
}

struct Daily: Decodable {
    let time: [String]
    let weathercode : [Int16]
    let temperature_2m_max: [Double]
    let temperature_2m_min: [Double]
    let sunrise: [Date]
    let sunset: [Date]
    let precipitation_sum: [Double]
    let windspeed_10m_max: [Double]
}


