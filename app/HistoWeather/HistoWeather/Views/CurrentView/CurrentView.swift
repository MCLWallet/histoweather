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
	// Cached values when pull-to-reload or onAppear
	@State private var cachedDate: Date = Date()
	@State private var cachedWeatherCode: String = "wrench.fill"
	@State private var cachedCurrentTemperature: Double = 0
	@State private var cachedMinTemperature: Double = 0
	@State private var cachedMaxTemperature: Double = 0
	@State private var cachedPrecipitation: Double = 0
	@State private var cachedWindSpeed: Double = 0
	@State private var cachedSunrise: Date = Date()
	@State private var cachedSunset: Date = Date()
	
	@State private var currentBackgroundColor: LinearGradient = TemperatureColorRange.cool.gradient
	@State private var currentNavigationBarColor: Color = .darkBlue
	
	@Binding var currentLocation: CLLocation
	@Binding var navigationTitle: String
	
	@ObservedObject var locationManager = LocationManager.shared
	@ObservedObject var unitsManager = UnitsManager.shared
    
    @State var showError = true
    
	var body: some View {
		NavigationStack {
			ScrollView {
				// Date & Location View
				HStack {
					VStack(alignment: .leading) {
						Text("\((dayWeather.last?.time ?? cachedDate).formatted(date: .abbreviated, time: .shortened))")
							.font(.title3)
					}
					.padding(.bottom)
					.padding(.leading)
					Spacer()
				}
				// Temperature View
				VStack {
					Image(systemName: dayWeather.last?.weathericoncode ?? cachedWeatherCode)
						.resizable()
						.scaledToFit()
						.padding(.all)
						.frame(maxWidth: 250)
					Text("\(String(format: "%.0f", Double(truncating: dayWeather.last?.temperature ?? cachedCurrentTemperature as NSNumber))) \(unitsManager.currentTemperatureUnit.rawValue)")
						.font(.largeTitle)
						.fontWeight(.light)
						.multilineTextAlignment(.center)
						.padding(.bottom)
						.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
					HStack {
						Text("high")
						Text("\(String(format: "%.0f", day.first?.temperature_2m_max ?? cachedMaxTemperature)) \(unitsManager.currentTemperatureUnit.rawValue)")
							.bold()
						Text("low")
						Text("\(String(format: "%.0f", day.first?.temperature_2m_min ?? cachedMinTemperature)) \(unitsManager.currentTemperatureUnit.rawValue)")
							.bold()
					}
					.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
				}
				.padding(.all)
				// Other Weather Parameters View
				HStack {
					VStack(alignment: .leading) {
						Label("precipitation", systemImage: "cloud.rain.fill")
						Text(String(format: "%.1f mm", day.first?.precipitation_sum ?? cachedPrecipitation))
							.fontWeight(.bold)
					}.padding(.all)
					Spacer()
					VStack(alignment: .trailing) {
						Label("windSpeed", systemImage: "wind")
						Text("\(dayWeather.last?.windspeed ?? cachedWindSpeed as NSNumber) km/h")
							.fontWeight(.bold)
					}.padding(.all)
					
				}
				HStack {
					VStack(alignment: .leading) {
						Label("sunrise", systemImage: "sunrise.fill")
						Text("\((day.first?.sunrise ?? cachedSunrise).formatted(date: .omitted, time: .shortened))")
							.fontWeight(.bold)
					}.padding(.all)
					Spacer()
					VStack(alignment: .trailing) {
						Label("sunset", systemImage: "sunset.fill")
						Text("\((day.first?.sunset ?? cachedSunset).formatted(date: .omitted, time: .shortened))")
							.fontWeight(.bold)
					}.padding(.all)
				}
			}
            .alert("alert-title-error", isPresented: $showError, actions: { // Show an alert if an error appears
                Button("ok", role: .cancel) {
                    // Do nothing
                }
            }, message: {
                Text("alert-message-error")
            })
			.navigationTitle(navigationTitle)
			.navigationBarTitleDisplayMode(.automatic)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						reloadValuesWithDifferentUnit()
					}, label: {
						Text("\(unitsManager.currentTemperatureUnit.rawValue)")
							.font(.title)
					})
					.foregroundColor(.hWFontColor)
				}
			}
			.background(currentBackgroundColor)
			.toolbarBackground(currentNavigationBarColor, for: .navigationBar)
			.foregroundColor(.hWBlack)
		}
		.refreshable {
			reloadValues()
		}
		.onAppear {
			reloadValues()
		}
	}
	
	func setCache() {
		self.cachedDate = dayWeather.last?.time ?? Date()
		self.cachedWeatherCode = dayWeather.last?.weathericoncode ?? "wrench.fill"
		self.cachedCurrentTemperature = Double(truncating: dayWeather.last?.temperature ?? 0)
		self.cachedMaxTemperature = Double(truncating: (day.first?.temperature_2m_max ?? 0) as NSNumber)
		self.cachedMinTemperature = Double(truncating: (day.first?.temperature_2m_min ?? 0) as NSNumber)
		self.cachedPrecipitation = day.first?.precipitation_sum ?? 0
		self.cachedWindSpeed = Double(truncating: dayWeather.last?.windspeed ?? 0.0)
		self.cachedSunrise = day.first?.sunrise ?? Date()
		self.cachedSunset = day.first?.sunset ?? Date()
		
	}
	
	func setBackgroundColors() {
		self.currentBackgroundColor = getTemperatureGradient(
			temperature: Double(truncating: (dayWeather.last?.temperature ?? 0)),
				  unit: unitsManager.currentTemperatureUnit)
		self.currentNavigationBarColor = getNavigationBarColorByTemperature(
			temperature: Double(truncating: (dayWeather.last?.temperature ?? 0)),
				  unit: unitsManager.currentTemperatureUnit
			  )
	}
	
	func reloadValues() {
		setCache()
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
				setBackgroundColors()
				locationManager.stopUpdatingLocation()
			} catch let error {
				print("Error while refreshing weather: \(error)")
                showError = true
			}
		}
	}
	
	func reloadValuesWithDifferentUnit() {
		setCache()
		Task {
			do {
				try await model.fetchApi(
					unit: self.unitsManager.getCurrentOppositeUnit()
				)
				unitsManager.changeCurrentTemperatureUnit()
			} catch let error {
				print("Error while refreshing weather: \(error)")
                showError = true
			}
		}
	}
}

struct CurrentView_Previews: PreviewProvider {
	static var previews: some View {
		CurrentView(currentLocation: .constant(CLLocation(latitude: 48.20849, longitude: 16.37208)), navigationTitle: .constant("Wien"))
	}
}
