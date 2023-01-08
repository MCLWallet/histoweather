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
	
	@State private var model = CurrentViewModel()
	@Binding var currentLocation: CLLocation
	@Binding var navigationTitle: String
	
	@ObservedObject var locationManager = LocationManager.shared
	@ObservedObject var unitsManager = UnitsManager.shared

	var body: some View {
		NavigationStack {
			ScrollView {
				// Date & Location View
				HStack {
					VStack(alignment: .leading) {
						Text("\((dayWeather.last?.time ?? Date()).formatted(date: .abbreviated, time: .shortened))")
							.font(.title3)
					}
					.padding(.bottom)
					.padding(.leading)
					Spacer()
				}
				// Temperature View
				VStack {
					Image(systemName: dayWeather.last?.weathericoncode ?? "wrench.fill")
						.resizable()
						.scaledToFit()
						.padding(.all)
						.frame(maxWidth: 250)
					Text("\(String(format: "%.0f", Double(truncating: dayWeather.last?.temperature ?? 0))) \(unitsManager.currentTemperatureUnit.rawValue)")
						.font(.largeTitle)
						.fontWeight(.light)
						.multilineTextAlignment(.center)
						.padding(.bottom)
						.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
					HStack {
						Text("high")
						Text("\(String(format: "%.0f", day.first?.temperature_2m_max ?? 0)) \(unitsManager.currentTemperatureUnit.rawValue)")
							.bold()
						Text("low")
						Text("\(String(format: "%.0f", day.first?.temperature_2m_min ?? 0)) \(unitsManager.currentTemperatureUnit.rawValue)")
							.bold()
					}
					.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
				}
				// Other Weather Parameters View
				HStack {
					VStack(alignment: .leading) {
						Label("elevation", systemImage: "plusminus")
						Text("\(dayWeather.last?.elevation ?? 0.0)")
							.fontWeight(.bold)
					}.padding(.all)
					Spacer()
					VStack(alignment: .trailing) {
						Label("precipitation", systemImage: "cloud.rain.fill")
						Text(String(format: "%.1f", day.first?.precipitation_sum ?? 0))
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
			.navigationTitle(navigationTitle)
			.navigationBarTitleDisplayMode(.automatic)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						unitsManager.changeCurrentTemperatureUnit()
						Task {
							do {
								try await model.fetchApi(
									unit: self.unitsManager.getCurrentUnit()
								)
							} catch let error {
								print("Error while refreshing weather: \(error)")
							}
						}
					}, label: {
						Text("\(unitsManager.currentTemperatureUnit.rawValue)")
							.font(.title)
					})
					.foregroundColor(.hWFontColor)
				}
			}
			.background(
				getTemperatureGradient(
					temperature: Double(truncating: (dayWeather.last?.temperature ?? 0)),
					unit: unitsManager.currentTemperatureUnit)
			)
			.toolbarBackground(
				getNavigationBarColorByTemperature(
					temperature: Double(truncating: (dayWeather.last?.temperature ?? 0)),
					unit: unitsManager.currentTemperatureUnit
				),
				for: .navigationBar)
			.foregroundColor(.hWBlack)
		}
		.refreshable {
			Task {
				do {
					if !locationManager.locationBySearch {
						locationManager.startUpdatingLocation()
						model.setLocation(location: locationManager.userLocation)
					} else {
						model.setLocation(location: currentLocation)
					}
					try await model.fetchApi(
						unit: self.unitsManager.getCurrentUnit()
					)
					navigationTitle = model.getLocationTitle()
					locationManager.stopUpdatingLocation()
				} catch let error {
					print("Error while refreshing weather: \(error)")
				}
			}
		}
		.onAppear {
			Task {
				do {
					if !locationManager.locationBySearch {
						model.setLocation(location: locationManager.userLocation)
					} else {
						model.setLocation(location: currentLocation)
					}
					try await model.fetchApi(
						unit: self.unitsManager.getCurrentUnit()
					)
					navigationTitle = model.getLocationTitle()
					locationManager.stopUpdatingLocation()
				} catch let error {
					print("Error while refreshing weather: \(error)")
				}
			}
		}
	}
}

struct CurrentView_Previews: PreviewProvider {
	static var previews: some View {
		CurrentView(currentLocation: .constant(CLLocation(latitude: 48.20849, longitude: 16.37208)), navigationTitle: .constant("Wien"))
	}
}
