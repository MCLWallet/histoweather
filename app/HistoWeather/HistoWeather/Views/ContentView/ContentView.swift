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
    @State var selectedTab: Int
	@State private var oldSelectedTab = 1
	@State var sheetIsPresenting = false
	@State var currentLocation: CLLocation = LocationManager.shared.userLocation
	@State var currentLocationName: String = "N/A"
    @ObservedObject var networkChecker = NetworkChecker.shared
    
    var body: some View {
        Group {
            TabView(selection: $selectedTab) {
                if networkChecker.connected {
                    CurrentView(currentLocation: $currentLocation, navigationTitle: $currentLocationName)
                    .tabItem {
                    Label("today", systemImage: "cloud.sun.fill")
                }
                    .tag(1)
                ForecastView(currentLocation: $currentLocation, navigationTitle: $currentLocationName)
                    .tabItem {
                        Label("forecast", systemImage: "calendar")
                    }
                    .tag(2)
                GraphView(currentLocation: $currentLocation, navigationTitle: $currentLocationName)
                    .tabItem {
                        Label("Graph", systemImage: "chart.xyaxis.line")
                    }
                    .tag(3)
                SliderView(currentLocation: $currentLocation, navigationTitle: $currentLocationName)
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
                } else {
                    VStack(alignment: .center) {
                        Image(systemName: "wifi.slash")
                            .resizable()
                            .scaledToFit()
                            .padding(.all)
                            .frame(maxWidth: 250)
                        Text("checkInternet")
                            .bold()
                            .font(.title)
                    }
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
				SearchView(currentLocation: $currentLocation, currentLocationName: $currentLocationName, lastSelectedTab: self.oldSelectedTab)
			})
			.accentColor(.hWFontColor)	
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selectedTab: 1)
    }
}
