//
//  DayWeatherPersistence.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 02.12.22.
//

import CoreData

struct DayWeatherPersistence {
    private let context = PersistenceController.shared.backgroundContext
    static func fetchDayWeather() -> NSFetchRequest<DayWeather> {
        let request = DayWeather.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
    static func fetchAllDayWeather() -> NSFetchRequest<DayWeather> {
        let request = DayWeather.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    static func fetchDay() -> NSFetchRequest<Day> {
        let request = Day.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        return request
    }
    func addDayWeather(from weather: Weather, city: String, country: String) async {
        await context.perform {
            _ = DayWeather(weather: weather, city: city, country: country, context: context) }
        context.saveContext()
    }
    func removeAllDayWeather() async throws {
        try await context.perform {
            try context.fetch(DayWeatherPersistence.fetchAllDayWeather()).forEach {
                context.delete($0)
            }
            context.saveContext()
        }
    }
}

func convertDate(date: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-mm-dd"
    return dateFormatter.date(from: date)!
}

extension DayWeather {
    convenience init(weather: Weather,
                     city: String,
                     country: String,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.city = city
        self.country = country
        self.longitude = weather.longitude
        self.latitude = weather.latitude
        self.time = weather.current_weather.time
        self.elevation = (weather.elevation) as NSNumber
        self.temperature = (weather.current_weather.temperature) as NSNumber
        self.weathericoncode = weatherCodeToIcon(weatherCode: weather.current_weather.weathercode)
        self.windspeed = (weather.current_weather.windspeed) as NSNumber
        self.winddirection = (weather.current_weather.winddirection) as NSNumber
        for i in 0...(weather.daily.temperature_2m_max.count - 1) {
            addToDay(Day(day: DayEntry(time: convertDate(date: weather.daily.time[i]),
                              weathericoncode: weatherCodeToIcon(weatherCode: weather.daily.weathercode[i]),
                              temperature_2m_max: weather.daily.temperature_2m_max[i],
                              temperature_2m_min: weather.daily.temperature_2m_min[i],
                              sunrise: weather.daily.sunrise[i],
                              sunset: weather.daily.sunset[i],
                              precipitation_sum: weather.daily.precipitation_sum[i],
                              windspeed_10m_max: weather.daily.windspeed_10m_max[i]
                             ),
                         context: context))
        }
    }
}

extension Day {
    convenience init(day: DayEntry,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        self.time = day.time
        self.weathericoncode = day.weathericoncode
        self.temperature_2m_max = day.temperature_2m_max
        self.temperature_2m_min = day.temperature_2m_min
        self.sunrise = day.sunrise
        self.sunset = day.sunset
        self.precipitation_sum = day.precipitation_sum
        self.windspeed_10m_max = day.windspeed_10m_max
    }
}
