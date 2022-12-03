//
//  ContentView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 24.11.22.
//

import SwiftUI
import CoreData

struct ContentView: View {
//     Fetch automatically data from the database
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchFriends(),
                  animation: .default)
    private var dayWeather: FetchedResults<DayWeather>

    @State private var model = ContentViewModel()
    var body: some View {


        TabView {
            CurrentView()
                .tabItem {
                    Label("fdsaf", systemImage: "cloud.sun.fill")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
