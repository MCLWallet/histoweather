//
//  ContentView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 24.11.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
	@ObservedObject var locationManager = LocationManager.shared
    var body: some View {
		Group {
			switch locationManager.authStatus {
			case "notDetermined", "restricted":
				LocationRequestView()
			case "denied", "maybeLater":
				SearchView()
			case "authorizedAlways", "authorizedWhenInUse":
				TabView {
					CurrentView()
						.tabItem {
							Label("Weather", systemImage: "cloud.sun.fill")
						}
						.tag(1)
					ForecastView()
						.tabItem {
							Label("Forecast", systemImage: "calendar")
						}
						.tag(2)
					SliderView()
						.tabItem {
							Label("History", systemImage: "clock.arrow.circlepath")
						}
						.tag(3)
					SearchView()
						.tabItem {
							Label("Search", systemImage: "magnifyingglass")
						}
						.tag(4)
				}
				.accentColor(Color("DarkBlue"))
			default:
				LocationRequestView()
			}
		}
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
