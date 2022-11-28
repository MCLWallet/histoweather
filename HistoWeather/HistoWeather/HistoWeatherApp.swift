//
//  HistoWeatherApp.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 24.11.22.
//

import SwiftUI

@main
struct HistoWeatherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LocationView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
