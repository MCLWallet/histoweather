//
//  CurrentView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 01.12.22.
//

import SwiftUI
import MapKit

struct WeatherIcon: Identifiable {
	let id = UUID()
	let weatherCode: [Int16]
	let description: String
	let sfImageID: String
}

struct CurrentView: View {
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchDayWeather(),
                  animation: .default)
    private var dayWeather: FetchedResults<DayWeather>

    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchDay(),
                  animation: .default)
    private var day: FetchedResults<Day>
    @State private var model = ForecastViewModel()
	@ObservedObject var locationManager = LocationManager.shared
	var body: some View {
        NavigationStack {

			// Top Container
			HStack {
				// Date & Location View
				VStack(alignment: .leading) {
                    Text(Coordinates.locationName)
						.font(.largeTitle)
                    Text("\((dayWeather.last?.time ?? Date()).formatted(date: .abbreviated, time: .shortened))")
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
				Text("\(dayWeather.last?.temperature ?? 0.0) °C")
					.font(.largeTitle)
					.fontWeight(.light)
					.multilineTextAlignment(.center)
					.padding(.bottom)
					.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
				HStack {
					Text("high")
                    Text("\(String(format: "%lld", day.first?.temperature_2m_max ?? 0)) °C")
						.bold()
					Text("low")
                    Text("\(String(format: "%lld", day.first?.temperature_2m_min ?? 0)) °C")
						.bold()
				}
				.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
				// Debug Log Coordinates
//                Text("\(dayWeather.last?.latitude ?? 0), \(dayWeather.last?.longitude ?? 0)")
//                Text("\(Coordinates.latitude), \(Coordinates.longitude)")
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
                    Text("\(String(format: "%.1f", day.first?.precipitation_sum ?? 0)) mm")
                        .fontWeight(.bold)
                }.padding(.all)
			}
            HStack {
                VStack(alignment: .leading) {
					Label("winddirection", systemImage: "location.fill")
                    Text("\(dayWeather.last?.winddirection ?? 0.0)°")
                        .fontWeight(.bold)
                }.padding(.all)
                Spacer()
                VStack(alignment: .trailing) {
					Label("windSpeed", systemImage: "wind")
                    Text("\(dayWeather.last?.windspeed ?? 0.0) km/h")
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
                try await model.fetchApi()
            } catch let error {
                print("Error while refreshing weather: \(error)")
            }
        }
        .onAppear {
            Task {
                do {
                    try await model.fetchApi()
                } catch let error {
                    print("Error while refreshing weather: \(error)")
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
