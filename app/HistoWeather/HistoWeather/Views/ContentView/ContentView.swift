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
    @State var tab: Int
    
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
                        Label("Forecast", systemImage: "calendar")
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
            .background(.white)
        }
        .onAppear {
                        // correct the transparency bug for Tab bars
                        let tabBarAppearance = UITabBarAppearance()
                        tabBarAppearance.configureWithOpaqueBackground()
                        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                        // correct the transparency bug for Navigation bars
                        let navigationBarAppearance = UINavigationBarAppearance()
                        navigationBarAppearance.configureWithOpaqueBackground()
                        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
                    }
    }
    
}

struct Coordinates{
    static var coordinate: CLLocationCoordinate2D = LocationManager.shared.userlocation != nil
    ? LocationManager.shared.userlocation!.coordinate : CLLocationCoordinate2D(latitude: 48.20849, longitude: 16.37208)
    
    static var locationName: String = (LocationManager.shared.userlocation == nil) ? "Vienna" :  "gpsLocation"
    static var longitude:Double = coordinate.longitude
    static var latitude:Double = coordinate.latitude
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(tab: 4)
    }
}
