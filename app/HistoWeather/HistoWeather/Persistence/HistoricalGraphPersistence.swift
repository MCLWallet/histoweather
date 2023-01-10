//
//  HistoricalPersistenceGraph.swift
//  HistoWeather
//
//  Created by Milos Stojiljkovic on 06.01.23.
//

import Foundation
import CoreData

struct HistoricalGraphPersistence {
    private let context = PersistenceController.shared.backgroundContext

    static func fetchHistoricalGraph() -> NSFetchRequest<HistoricalGraph> {
        let request = HistoricalGraph.fetchRequest()
        request.sortDescriptors = []
        return request
    }

    static func fetchAllHistoricalGraph() -> NSFetchRequest<HistoricalGraph> {
        let request = HistoricalGraph.fetchRequest()
        request.sortDescriptors = []
        return request
    }

    static func fetchHistoricalHourly(predicate: NSPredicate) -> NSFetchRequest<HistoricalHourly> {
        let request = HistoricalHourly.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        return request
    }
    
    func addHistoricalGraph(historicalGraphDecodable: HistoricalGraphDecodable, city: String, country: String) async {
        
        await context.perform {
            _ = HistoricalGraph(historicalGraph: historicalGraphDecodable, city: city, country: country, context: context)

            context.saveContext() // saveContext moved inside the perform scope
        }
    }

    func removeAllEntries() async throws {
        try await context.perform {
            try
            context.fetch(HistoricalGraphPersistence.fetchAllHistoricalGraph())
                .forEach {
                context.delete($0)
            }
            context.saveContext()
        }
    }
}

extension HistoricalGraph {
    convenience init(historicalGraph: HistoricalGraphDecodable, city: String, country: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.city = city
        self.country = country
		
        for i in 0...historicalGraph.hourly.time.count - 1 {
            addToHistoricalHourly(
                HistoricalHourly(
					day: HistoricalHourlyEntry(
						time: convertDate(date: historicalGraph.hourly.time[i], format: "yyyy-MM-dd'T'HH:mm"),
						temperature_2m: historicalGraph.hourly.temperature_2m[i],
						rain: historicalGraph.hourly.rain[i],
						windspeed_10m: historicalGraph.hourly.windspeed_10m[i]
					),
				context: context))
        }
    }
}

extension HistoricalHourly {
    convenience init(day: HistoricalHourlyEntry,
                     context: NSManagedObjectContext) {
        self.init(context: context)

        self.time = day.time
        self.temperature_2m = day.temperature_2m
        self.rain = day.rain
        self.windspeed_10m = day.windspeed_10m
    }
}
