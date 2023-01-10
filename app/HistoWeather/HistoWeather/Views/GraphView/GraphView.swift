//
//  GraphView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 28.12.22.
//

import SwiftUI
import Charts
import CoreLocation

struct GraphView: View {
    @FetchRequest(fetchRequest: HistoricalGraphPersistence.fetchAllHistoricalGraph(),
                  animation: .default)
    private var historicalGraph: FetchedResults<HistoricalGraph>
	
	@State private var model = GraphViewModel()
	@State private var dayOne: Date = getDateByDaysAdded(from: Date(), daysAdded: -9)
	@State private var dayTwo: Date = getDateByDaysAdded(from: Date(), daysAdded: -7)
	@State private var selectedParameter: LineGraphParameter = .temperature
	@State private var lineGraphData: [LineGraphDate] = []
	
	@Binding var currentLocation: CLLocation
	@Binding var navigationTitle: String
	
	@ObservedObject var locationManager = LocationManager.shared
	@ObservedObject var unitsManager = UnitsManager.shared
	
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
					// TODO: Condition if dayOne is bigger than dayTwo
					// TODO: App crashes when doing bigger API calls
                    DatePicker(
						selection: $dayOne,
                        displayedComponents: [.date],
                        label: { Text("Day 1") }
                    )
					.onChange(of: dayOne, perform: { _ in
						Task {
							await reloadValues()
						}
					})
                    DatePicker(
                        selection: $dayTwo,
                        displayedComponents: [.date],
                        label: { Text("Day 2") }
                    )
					.onChange(of: dayTwo, perform: { _ in
						Task {
							await reloadValues()
						}
					})
                }
                .padding(.bottom, 30)
                Picker("Parameter", selection: $selectedParameter) {
                    Text("Temperature").tag(LineGraphParameter.temperature)
                    Text("Wind Speed").tag(LineGraphParameter.windSpeed)
                    Text("Rain").tag(LineGraphParameter.rain)
                }
                .pickerStyle(.segmented)
				// TODO: change parameters
				// TODO: localize dates and strings
                Chart(lineGraphData) {
                    LineMark(
						x: .value("Hours", $0.time),
                        y: .value("Temperature", $0.temperature)
                    )
                    .foregroundStyle(by: .value("Day", $0.day))
                }
                .chartXAxisLabel("Time")
                .chartYAxisLabel("°C")
                .frame(minHeight: 420)
                .padding(.all)
            }
			.navigationTitle(navigationTitle)
            .padding(.all)
            .navigationTitle("Title")
        }
        .onAppear {
			Task {
				await reloadValues()
			}
        }
    }
	private func reloadValues() async {
		do {
			if !locationManager.locationBySearch {
				model.setLocation(location: locationManager.userLocation)
			} else {
				model.setLocation(location: currentLocation)
			}
			try await model.fetchApi(
				tempUnit: self.unitsManager.getCurrentUnit(),
				startDate: dayOne,
				endDate: dayTwo
			)
			updateGraphData()
			navigationTitle = model.getLocationTitle()
			locationManager.stopUpdatingLocation()
		} catch let error {
			print("Error while refreshing weather: \(error)")
		}
	}
	
	private func updateGraphData() {
		var newLineGraphData: [LineGraphDate] = []
		if let hourlyData = historicalGraph.last?.historicalHourly {
				for item in hourlyData {
					if areDatesOnSameDay(date1: (item as AnyObject).time ?? Date(), date2: dayOne)
						|| areDatesOnSameDay(date1: (item as AnyObject).time ?? Date(), date2: dayTwo) {
						newLineGraphData.append(
							LineGraphDate(
								day: getDayString(from: (item as AnyObject).time ?? Date()),
								time: getTimeString(from: (item as AnyObject).time ?? Date()),
								temperature: (item as AnyObject).temperature_2m,
								windSpeed: (item as AnyObject).windspeed_10m,
								rain: (item as AnyObject).rain)
						)
					}
				}
			lineGraphData = sortLineGraphDates(newLineGraphData) 
			}
	}
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(currentLocation: .constant(CLLocation(latitude: 48.20849, longitude: 16.37208)), navigationTitle: .constant("Wien"))
    }
}
