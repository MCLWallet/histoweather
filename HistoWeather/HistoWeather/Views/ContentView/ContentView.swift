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
			if locationManager.userlocation == nil {
				LocationRequestView()
			} else {
				TabView {
					CurrentView()
						.tabItem {
							Label("Weather", systemImage: "cloud. sun.fill")
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
				//        .refreshable { // Add a pull-to-refresh to the list
				//            await refreshWeather()
				//             func refreshWeather() async {
				//                do {
				//                    try await model.refreshDayWeather()
				//                } catch let error {
				//                    print("Error while refreshing friends: \(error)")
				//                }
				//            }
				//        }
		//        Button("fdsfa"){
		//            func refreshWeather() async {
		//                do {
		//                    try await model.fetchapi()
		//                } catch let error {
		//                    print("Error while refreshing friends: \(error)")
		//                }
		//            }
		//        }
			}
		}

		
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
