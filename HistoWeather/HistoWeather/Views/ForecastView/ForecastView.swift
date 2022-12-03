//
//  ForecastView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 01.12.22.
//

import SwiftUI

struct Forecast: Identifiable {
	let id = UUID()
	let date: String
	let temperature: String
	let sfImageID: String
}

private var forecastFakeData = [
	Forecast(
		date: "Wed\n18.11.",
		temperature: "13°C",
		sfImageID: "cloud"
	),
	Forecast(
		date: "Thu\n19.11.",
		temperature: "8°C",
		sfImageID: "cloud.rain"
	),
	Forecast(
		date: "Fri\n20.11.",
		temperature: "13°C",
		sfImageID: "cloud.sun"
	),
	Forecast(
		date: "Sat\n21.11.",
		temperature: "8°C",
		sfImageID: "sun.max"
	),
	Forecast(
		date: "Sun\n22.11.",
		temperature: "13°C",
		sfImageID: "sun.max"
	),
	Forecast(
		date: "Mon\n23.11.",
		temperature: "8°C",
		sfImageID: "cloud.bolt.rain"
	),
	Forecast(
		date: "Tue\n24.11.",
		temperature: "8°C",
		sfImageID: "wind.snow"
	)
]

struct ForecastView: View {
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchFriends(),
                  animation: .default)
    private var dayWeather: FetchedResults<DayWeather>

    @State private var model = ForecastViewModel()
    var body: some View {
        
//        ForEach(dayWeather) { friend in
//            Text("\(friend.longitude) fjdaslfjslfads")
//        }
		VStack {
			// Top Container
			HStack {
				Spacer()
				// Date & Location View
				VStack(alignment: .trailing) {
					Text("vienna")
						.font(.largeTitle)
					Text("fakeDate")
						.font(.title3)
				}.padding()
			}
			Spacer()
			List(forecastFakeData) { index in
				HStack {
					Text(index.date)
					Spacer()
					Text(index.temperature)
						.fontWeight(.bold)
					Image(systemName: index.sfImageID)
				}
			}
        }
        .refreshable {
            await model.fetchapi()
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}
