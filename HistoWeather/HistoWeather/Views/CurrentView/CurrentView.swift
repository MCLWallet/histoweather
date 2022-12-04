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

private var weatherIconList = [
	WeatcherIcon(
		weatherCode: [0],
		description: "Clear sky",
		sfImageID: "sun.max"),
	WeatcherIcon(
		weatherCode: [1, 2, 3],
		description: "Mainly clear, partly cloudy, and overcast",
		sfImageID: "cloud.sun"),
	WeatcherIcon(
		weatherCode: [45, 48],
		description: "Fog and depositing rime fog",
		sfImageID: "cloud.fog"),
	WeatcherIcon(
		weatherCode: [51, 53, 55],
		description: "Drizzle: Light, moderate, and dense intensity",
		sfImageID: "cloud.drizzle"),
	WeatcherIcon(
		weatherCode: [56, 57],
		description: "Freezing Drizzle: Light and dense intensity",
		sfImageID: "cloud.drizzle"),
	WeatcherIcon(
		weatherCode: [61, 63, 65],
		description: "Rain: Slight, moderate and heavy intensity",
		sfImageID: "cloud.rain"),
	WeatcherIcon(
		weatherCode: [66, 67],
		description: "Freezing Rain: Light and heavy intensity",
		sfImageID: "cloud.sleet"),
	WeatcherIcon(
		weatherCode: [71, 73, 75],
		description: "Snow fall: Slight, moderate, and heavy intensity",
		sfImageID: "snowflake"),
	WeatcherIcon(
		weatherCode: [77],
		description: "Snow grains",
		sfImageID: "cloud.snow"),
	WeatcherIcon(
		weatherCode: [80, 81, 82],
		description: "Rain showers: Slight, moderate, and violent",
		sfImageID: "cloud.heavyrain"),
	WeatcherIcon(
		weatherCode: [85, 86],
		description: "Snow showers slight and heavy",
		sfImageID: "cloud.snow"),
	WeatcherIcon(
		weatherCode: [95],
		description: "Thunderstorm: Slight or moderate",
		sfImageID: "cloud.bolt"),
	WeatcherIcon(
		weatherCode: [96, 99],
		description: "Thunderstorm with slight and heavy hail",
		sfImageID: "cloud.bolt.rain")
]

struct CurrentView: View {
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchFriends(),
                  animation: .default)
    private var dayWeather: FetchedResults<DayWeather>
	
	@ObservedObject var locationManager = LocationManager.shared
	
    @State private var model = ForecastViewModel()
	var body: some View {
		let coordinate = self.locationManager.userlocation != nil
		? self.locationManager.userlocation!.coordinate : CLLocationCoordinate2D()

		return ScrollView {
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
			// Middle Container
			VStack {
				// Current Weather View
				Image(systemName: "cloud")
					.resizable()
					.frame(width: 150, height: 120)
				Text("fakeCurrentTemperature")
					.font(.largeTitle)
					.fontWeight(.light)
					.multilineTextAlignment(.center)
					.padding(.bottom)
					.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
				HStack {
					Text("high")
					Text("12°C")
						.bold()
					Text("low")
					Text("8°C")
						.bold()
				}
				.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
				// Debug Log Coordinates
				Text("\(coordinate.latitude), \(coordinate.longitude)")
			}
            .refreshable {
                await model.fetchapi()
            }
			Spacer()
			// Humidity & Windspeed
			HStack {
				VStack(alignment: .leading) {
					Text("humidity")
					Text("fakeHumidity")
						.fontWeight(.bold)
				}.padding(.all)
				Spacer()
				VStack(alignment: .trailing) {
					Text("windSpeed")
                    Text("\(dayWeather.randomElement()?.longitude ?? 5.6)")
//                    Text("\(dayWeather.?? 5.6)")
						.fontWeight(.bold)
				}.padding(.all)
			}
			// UV-Index & Rain
			HStack {
				VStack(alignment: .leading) {
					Text("uvIndex")
					Text("fakeUvIndex")
						.fontWeight(.bold)
				}.padding(.all)
				Spacer()
				VStack(alignment: .trailing) {
					Text("rain")
					Text("fakeRain")
						.fontWeight(.bold)
				}.padding(.all)
			}
		}
        .refreshable {
            await model.fetchapi()
        }
//        .onAppear {
//            let task = Task
//                await model.fetchapi()
//		}
	}
}

struct CurrentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentView()
    }
}
