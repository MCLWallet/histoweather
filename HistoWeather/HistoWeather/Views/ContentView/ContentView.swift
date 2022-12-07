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
    
    @ObservedObject var locationManager = LocationManager.shared
        
    @State var coordinates: Coordinates = Coordinates()
    @State var tab = (LocationManager.shared.authStatus != "authorizedAlways" && LocationManager.shared.authStatus != "authorizedWhenInUse") ? 1 : 4
    var body: some View {

		Group {
            TabView(selection: $tab) {
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
                SearchView(tab: $tab)
                        .tabItem {
                            Label("Search", systemImage: "location.magnifyingglass")
                        }
                        .tag(4)
				}
				.accentColor(Color("DarkBlue"))
//                .onAppear(){
//                    Coordinates.coordinate = self.locationManager.userlocation != nil
//                            ? self.locationManager.userlocation!.coordinate : CLLocationCoordinate2D()
//                }
//                .onChange(of: self.locationManager) { newValue in
//                    Coordinates.coordinate = self.locationManager.userlocation != nil
//                            ? self.locationManager.userlocation!.coordinate : CLLocationCoordinate2D()
//                }
		}
    }

}

struct Coordinates{
        static var coordinate: CLLocationCoordinate2D = LocationManager.shared.userlocation != nil
        ? LocationManager.shared.userlocation!.coordinate : CLLocationCoordinate2D()
        static var longitude:Double = coordinate.longitude
    static var latitude:Double = coordinate.latitude
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
