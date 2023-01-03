//
//  HistoricalWeatherPersistence.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 23.12.22.
//
//
import Foundation
import CoreData

struct HistoricalWeatherPersistence {
    private let context = PersistenceController.shared.backgroundContext

    static func fetchHistoricalWeather() -> NSFetchRequest<HistoricalWeather> {
        let request = HistoricalWeather.fetchRequest()
        request.sortDescriptors = []
        return request
    }

    static func fetchAllHistoricalWeather() -> NSFetchRequest<HistoricalWeather> {
        let request = HistoricalWeather.fetchRequest()
        request.sortDescriptors = []
        return request
    }

    static func fetchHistoricalDaily(predicate: NSPredicate) -> NSFetchRequest<HistoricalDaily> {
        let request = HistoricalDaily.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        return request
    }

    func addHistoricalWeather(from historicalWeatherDecodable: HistoricalWeatherDecodable, city: String, country: String) async {
        await context.perform {
            
            let x = HistoricalWeather(historicalWeather: historicalWeatherDecodable, city: city, country: country, context: context)
            print("\nHERE:\n \(x) \n\n")
        }
        
        context.saveContext()

    }

    func removeAllEntries() async throws {
        try await context.perform {
            try context.fetch(HistoricalWeatherPersistence.fetchAllHistoricalWeather()).forEach {
                context.delete($0)
            }
            context.saveContext()
        }
    }
}

extension HistoricalDaily {
    convenience init(day: HistoricalDailyEntry,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.time = day.time
        self.weathericoncode = day.weathericoncode
        self.temperature_2m_max = day.temperature_2m_max
        self.temperature_2m_min = day.temperature_2m_min
    }
}

extension HistoricalWeather {
    convenience init(historicalWeather: HistoricalWeatherDecodable, city: String, country: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.city = city
        self.country = country
        for i in 0...historicalWeather.daily.temperature_2m_max.count - 1{ // when i try to save more than 1800 entryies save context throws an error
            
            
            addToHistoricalDaily(HistoricalDaily(day: HistoricalDailyEntry(
                time: convertDate(date: historicalWeather.daily.time[i]),
                weathericoncode: weatherCodeToIcon(weatherCode: historicalWeather.daily.weathercode[i]),
                temperature_2m_max: historicalWeather.daily.temperature_2m_max[i],
                temperature_2m_min: historicalWeather.daily.temperature_2m_min[i]
            ), context: context))
        }
    }
}
