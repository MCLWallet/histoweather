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
    @ObservedObject var locationManager = LocationManager.shared
  
    var body: some Scene {
        WindowGroup {
			if locationManager.authStatus == "notDetermined" {
				LocationRequestView().environment(\.managedObjectContext, persistenceController.container.viewContext)
			} else {
				ContentView(selectedTab: (locationManager.authStatus != "authorizedAlways"
								  && locationManager.authStatus != "authorizedWhenInUse") ? 4 : 1)
					.environment(\.managedObjectContext, persistenceController.container.viewContext)
			}
        }
    }
}
