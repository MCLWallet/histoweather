//
//  DayWeatherPresistance.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 02.12.22.
//

import CoreData

struct DayWeatherPersistence {
    
    private let context = PersistenceController.shared.backgroundContext
    
    static func fetchDayWeather() -> NSFetchRequest<DayWeather> {
        print("fetching")
        let request = DayWeather.fetchRequest()
//        print("Lat:\(Coordinates.coordinate.latitude)   Long:\(Coordinates.coordinate.longitude)")
//        request.predicate = NSPredicate(format:"latitude == %@ AND longitude == %@", Coordinates.latitude as NSNumber, Coordinates.longitude as NSNumber)

        
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
//        request.predicate = NSPredicate(format: "dayweather.latitude == %d AND dayweather.longitude == %d", Coordinates.coordinate.latitude, Coordinates.coordinate.longitude)
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        return request
    }
    
    func addDayWeather(from weather: Weather) async {
        await context.perform {
            _ = DayWeather(weather: weather, context: context) }
        context.saveContext()
    }
    
    func removeAllFriends() async throws {
        try await context.perform {
            
            try context.fetch(DayWeatherPersistence.fetchAllDayWeather()).forEach {
                context.delete($0)
            }
            context.saveContext()
        }
    }
}


func weatherCodeToIcon(weatherCode: Int16) -> String{
    if weatherCode == 0  {
        return "sun.max"
    } else if weatherCode == 1 || weatherCode == 2 || weatherCode == 3 {
        return "cloud.sun"
    } else if weatherCode == 45 || weatherCode == 48 {
        return "cloud.fog"
    } else if weatherCode == 51 || weatherCode == 53 || weatherCode == 55 {
        return "cloud.drizzle"
    } else if weatherCode == 56 || weatherCode == 57 {
        return "cloud.drizzle"
    } else if weatherCode == 61 || weatherCode == 63 || weatherCode == 65 {
        return "cloud.rain"
    } else if weatherCode == 66 || weatherCode == 67 {
        return "cloud.sleet"
    } else if weatherCode == 71 || weatherCode == 73 || weatherCode == 75 {
        return "snowflake"
    } else if weatherCode == 77{
        return "cloud.snow"
    } else if weatherCode == 80 || weatherCode == 81 || weatherCode == 82 {
        return "cloud.heavyrain"
    } else if weatherCode == 85 || weatherCode == 86 {
        return "cloud.snow"
    } else if weatherCode == 95 {
        return "cloud.bolt"
    } else if weatherCode == 96 || weatherCode == 99 {
        return "cloud.bolt.rain"
    } else {
        return "wrench.fill"
    }
}

func converteDate(date: String) -> Date {
    let dateFromatter = DateFormatter()
    dateFromatter.dateFormat = "yyyy-mm-dd"
    return dateFromatter.date(from: date)!
}

extension DayWeather {
    
    convenience init(weather: Weather,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.longitude = weather.longitude
        self.latitude = weather.latitude
        self.time = weather.current_weather.time 
        self.elevation = (weather.elevation) as NSNumber
        self.temperature = (weather.current_weather.temperature) as NSNumber
        self.weathericoncode = weatherCodeToIcon(weatherCode: weather.current_weather.weathercode)
        self.windspeed = (weather.current_weather.windspeed) as NSNumber
        self.winddirection = (weather.current_weather.winddirection) as NSNumber
            
        for i in 0...(weather.daily.temperature_2m_max.count - 1) {
            addToDay(Day(d: d(time: converteDate(date: weather.daily.time[i]),
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
    
    convenience init(d: d,
                     context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.time = d.time
        self.weathericoncode = d.weathericoncode
        self.temperature_2m_max = d.temperature_2m_max
        self.temperature_2m_min = d.temperature_2m_min
        self.sunrise = d.sunrise
        self.sunset = d.sunset
        self.precipitation_sum = d.precipitation_sum
        self.windspeed_10m_max = d.windspeed_10m_max
    }
}

struct d {
    let time: Date
    let weathericoncode: String
    let temperature_2m_max: Double
    let temperature_2m_min: Double
    let sunrise: Date
    let sunset: Date
    let precipitation_sum: Double
    let windspeed_10m_max: Double
}
