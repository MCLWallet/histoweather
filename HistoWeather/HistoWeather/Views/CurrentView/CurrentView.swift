//
//  CurrentView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 01.12.22.
//

import SwiftUI
import MapKit

struct WeatcherIcon: Identifiable {
	let id = UUID()
	let weatherCode: [Int16]
	let description: String
	let sfImageID: String
}

struct CurrentView: View {
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchDayWeather(latitude: 0, longitude: 0),
                  animation: .default)
    private var dayWeather: FetchedResults<DayWeather>

    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchDay(latitude: 0, longitude: 0),
                  animation: .default)
    private var day: FetchedResults<Day>
	
	@ObservedObject var locationManager = LocationManager.shared
	@State private var searchText: String = ""
	
    @State private var model = ForecastViewModel()
	var body: some View {
		let coordinate = self.locationManager.userlocation != nil
		? self.locationManager.userlocation!.coordinate : CLLocationCoordinate2D()

		return NavigationStack {
			// Top Container
			HStack {
				// Date & Location View
				VStack(alignment: .leading) {
					Text("vienna")
						.font(.largeTitle)
					Text("fakeDate")
						.font(.title3)
				}.padding()
				Spacer()
			}
			// Middle Container
			VStack {
				// Current Weather View
                Image(systemName: dayWeather.last?.weathericoncode ?? "wrench.fill")
					.resizable()
					.scaledToFit()
					.padding(.all)
				Text("\(dayWeather.last?.temperature ?? 0.0)°C")
					.font(.largeTitle)
					.fontWeight(.light)
					.multilineTextAlignment(.center)
					.padding(.bottom)
					.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
				HStack {
					Text("high")
					Text("\(day.first?.temperature_2m_max ?? 0)")
						.bold()
					Text("low")
					Text("\(day.first?.temperature_2m_min ?? 0)")
						.bold()
				}
				.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
				// Debug Log Coordinates
//				Text("\(coordinate.latitude), \(coordinate.longitude)")
			}
			// Humidity & Windspeed
			HStack {
				VStack(alignment: .leading) {
					Label("elevation", systemImage: "plusminus")
					Text("\(dayWeather.last?.elevation ?? 0.0)")
						.fontWeight(.bold)
				}.padding(.all)
				Spacer()
                VStack(alignment: .trailing) {
					Label("precipitation", systemImage: "cloud.rain.fill")
                    Text("\(day.first?.precipitation_sum ?? 0)")
                        .fontWeight(.bold)
                }.padding(.all)
			}
            HStack {
                VStack(alignment: .leading) {
					Label("winddirection", systemImage: "location.fill")
                    Text("\(dayWeather.last?.winddirection ?? 0.0)")
                        .fontWeight(.bold)
                }.padding(.all)
                Spacer()
                VStack(alignment: .trailing) {
					Label("windSpeed", systemImage: "wind")
                    Text("\(dayWeather.last?.windspeed ?? 0.0)")
                        .fontWeight(.bold)
                }.padding(.all)
            }
            HStack {
                VStack(alignment: .leading) {
					Label("sunrise", systemImage: "sunrise.fill")
					Text("\((day.first?.sunrise ?? Date()).formatted(date: .omitted, time: .shortened))")
                        .fontWeight(.bold)
                }.padding(.all)
                Spacer()
                VStack(alignment: .trailing) {
					Label("sunset", systemImage: "sunset.fill")
					Text("\((day.first?.sunset ?? Date()).formatted(date: .omitted, time: .shortened))")
                        .fontWeight(.bold)
                }.padding(.all)
            }
		}
        .refreshable {
            do {
                try await model.fetchapi()
            } catch let error {
				print("Error while refreshing friends: \(error)")
            }
        }
        .onAppear {
            Task {
                do {
                    try await model.fetchapi()
                } catch let error {
                    print("Error while refreshing friends: \(error)")
                }
            }
		}

	}
}

struct CurrentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentView()
    }
}
