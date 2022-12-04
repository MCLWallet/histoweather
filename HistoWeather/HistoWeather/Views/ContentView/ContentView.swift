//
//  ContentView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 24.11.22.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {


		TabView {
			CurrentView()
				.tabItem {
					Label("Weather", systemImage: "cloud.sun.fill")
				}
				.tag(1)
			ForecastView()
				.tabItem {
					Label("Forecast", systemImage: "forward.fill")
				}
				.tag(2)
			SliderView()
				.tabItem {
					Label("History", systemImage: "clock.arrow.circlepath")
				}
				.tag(3)
		}
		.accentColor(Color("DarkBlue"))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
