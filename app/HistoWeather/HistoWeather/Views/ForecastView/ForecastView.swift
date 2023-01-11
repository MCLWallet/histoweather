//
//  ForecastView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 01.12.22.
//

import SwiftUI
import CoreLocation

struct ForecastView: View {
	@FetchRequest(fetchRequest: DayWeatherPersistence.fetchDayWeather(),
				  animation: .default)
	private var dayWeather: FetchedResults<DayWeather>
	
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchDay(),
                  animation: .none)
    private var day: FetchedResults<Day>
	
	@State private var model = ForecastViewModel()
	
	// Cached values when pull-to-reload or onAppear
//	@State private var cachedDays: [Day] = []
//	@State private var cachedMinTemperatures: [Double] = Array(repeating: 0.0, count: 7)
//	@State private var cachedMaxTemperatures: [Double] = Array(repeating: 0.0, count: 7)
//	@State private var cachedWeekDays: [Date] = Array(repeating: Date(), count: 7)
//	@State private var cachedWeatherIconCodes: [String] = Array(repeating: "wrench.fill", count: 7)
//
//	@State private var currentBackgroundColors: [Date: LinearGradient] = [:]
    
    // extension PersistenceController {
    //
    //    /// Only used for SwiftUI previews, **do not use this otherwise**
    //    /// Adds a list of `Item` to the an in memory `CoreData` context.
    //    static var preview: PersistenceController = {
    //        let result = PersistenceController(inMemory: true)
    //        let viewContext = result.container.viewContext
    //        for _ in 0..<4 {
//	@State private var bgIndex: Int = 0

	@Binding var currentLocation: CLLocation
	@Binding var navigationTitle: String
	
	@ObservedObject var locationManager = LocationManager.shared
	@ObservedObject var unitsManager = UnitsManager.shared
    
    @State var showError = false
    
    var body: some View {
        NavigationView {
			ScrollView {
				// Top Container
				ForEach(day) { index in
					HStack {
						Text("\((index.time ?? Date()).formatted(.dateTime.weekday(.wide)))")
							.font(.title3)
							.fontWeight(.medium)
							.foregroundColor(.hWBlack)
							.frame(minWidth: 150, alignment: .leading)
						Spacer()
							Image(systemName: index.weathericoncode ?? "wrench.fill")
								.font(.title)
								.foregroundColor(.hWBlack)
                        Text("\(String(format: "%.0f / %.0f", index.temperature_2m_min, index.temperature_2m_max)) \(unitsManager.currentTemperatureUnit.rawValue)")
							.font(.title2)
							.foregroundColor(.hWBlack)
							.padding(.leading)
							.frame(minWidth: 80)
					}
					.padding(.all)
					.background(
						getTemperatureGradient(temperature: Double(index.temperature_2m_max), unit: unitsManager.currentTemperatureUnit)
					)
					.cornerRadius(20)
					.padding(.all, 10)
				}
			}
			.onAppear {
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
                        showError = true
					}
				}
			}
			.refreshable {
				await reloadValues()
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
        }
    }
	
	private func reloadValues() async {
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
	
//	func setCache() {
//		var index: Int = 0
//		for item in day {
//			self.cachedMinTemperatures[index] = item.temperature_2m_min
//			self.cachedMaxTemperatures[index] = item.temperature_2m_max
//			self.cachedWeekDays[index] = item.time ?? Date()
//			self.cachedWeatherIconCodes[index] = item.weathericoncode ?? "wrench.fill"
//			index += 1
//		}
//	}
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
		ForecastView(currentLocation: .constant(CLLocation(latitude: 48.20849, longitude: 16.37208)), navigationTitle: .constant("Wien"))
    }
}
