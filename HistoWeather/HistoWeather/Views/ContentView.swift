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
					Label("Today", systemImage: "cloud.sun.fill")
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
		.accentColor(/*@START_MENU_TOKEN@*/Color("DarkBlue")/*@END_MENU_TOKEN@*/)
		
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
