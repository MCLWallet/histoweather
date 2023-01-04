//
//  ContentView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 24.11.22.
//

import SwiftUI
import CoreData
import MapKit

struct ContentView: View {
    @ObservedObject var locationManager: LocationManager = LocationManager.shared
    @State var coordinates: Coordinates = Coordinates()
    @State var selectedTab: Int
	@State private var oldSelectedTab = 1
	
	@State var sheetIsPresenting = false
	
    var body: some View {
        Group {
            TabView(selection: $selectedTab) {
                CurrentView()
                    .tabItem {
                        Label("today", systemImage: "cloud.sun.fill")
                    }
                    .tag(1)
                ForecastView()
                    .tabItem {
                        Label("forecast", systemImage: "calendar")
                    }
                    .tag(2)
				GraphView()
					.tabItem {
						Label("Graph", systemImage: "chart.xyaxis.line")
					}
					.tag(3)
                SliderView()
                    .tabItem {
                        Label("Slider", systemImage: "slider.horizontal.2.gobackward")
                    }
                    .tag(4)
				Text("")
					.tabItem {
						Label("Search", systemImage: "location.magnifyingglass")
					}
					.tag(5)
					.onAppear {
						self.sheetIsPresenting = true
					}
            }
			.onChange(of: selectedTab) {
				if selectedTab == 5 {
					self.sheetIsPresenting = true
				} else {
					self.oldSelectedTab = $0
				}
			}
			.sheet(isPresented: $sheetIsPresenting, onDismiss: {
				self.selectedTab = self.oldSelectedTab
			}, content: {
				SearchView(lastSelectedTab: self.oldSelectedTab)
			})
            .accentColor(Color("DarkBlue"))
        }
    }
}

struct Coordinates {
    static var coordinate: CLLocationCoordinate2D = LocationManager.shared.userLocation != nil
    ? LocationManager.shared.userLocation!.coordinate : CLLocationCoordinate2D(latitude: 48.20849, longitude: 16.37208)
    static var locationName: String = (LocationManager.shared.userLocation == nil) ? "Vienna" :  "gpsLocation"
	static var locationCountry: String = LocationManager.shared.userLocationCountry
    static var longitude: Double = coordinate.longitude
    static var latitude: Double = coordinate.latitude
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: 1)
    }
}
