//
//  ForecastView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 01.12.22.
//

import SwiftUI

struct ForecastView: View {
	@FetchRequest(fetchRequest: DayWeatherPersistence.fetchDayWeather(),
				  animation: .default)
	private var dayWeather: FetchedResults<DayWeather>
	
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchDay(),
                  animation: .none)
    private var day: FetchedResults<Day>
	
	@State private var model = ForecastViewModel()
	var contentViewModel: ContentViewModel = ContentViewModel()
	
	@ObservedObject var unitsManager = UnitsManager.shared
    
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
							Text(String(format: "%.0f / %.0f", index.temperature_2m_min, index.temperature_2m_max))
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
				if model.getLocationTitle() == "N/A" {
					Task {
						LocationManager.shared.startUpdatingLocation()
						do {
							try await model.fetchApi(
								unit: self.unitsManager.getCurrentUnit(),
								latitude: LocationManager.shared.userLocation.coordinate.latitude,
								longitude: LocationManager.shared.userLocation.coordinate.longitude
							)
						} catch let error {
							print("Error while refreshing friends: \(error)")
						}
					}
					LocationManager.shared.stopUpdatingLocation()
				}
			}
			.refreshable {
				Task {
					LocationManager.shared.startUpdatingLocation()
					do {
						try await model.fetchApi(
							unit: self.unitsManager.getCurrentUnit(),
							latitude: LocationManager.shared.userLocation.coordinate.latitude,
							longitude: LocationManager.shared.userLocation.coordinate.longitude
						)
					} catch let error {
						print("Error while refreshing friends: \(error)")
					}
				}
				LocationManager.shared.stopUpdatingLocation()
			}
			.navigationTitle(model.getLocationTitle())
			.navigationBarTitleDisplayMode(.automatic)
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button(action: {
						unitsManager.changeCurrentTemperatureUnit()
						Task {
							do {
								try await model.fetchApi(
									unit: self.unitsManager.getCurrentUnit(),
									latitude: LocationManager.shared.userLocation.coordinate.latitude,
									longitude: LocationManager.shared.userLocation.coordinate.longitude
								)
							} catch let error {
								print("Error while refreshing friends: \(error)")
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
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}
