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
    @FetchRequest(fetchRequest: HistoricalGraphPersistence.fetchHistoricalGraph(),
                  animation: .default)
    private var historicalGraph: FetchedResults<HistoricalGraph>
	
	@State private var model = GraphViewModel()
	@State private var selectedParameter: LineGraphParameter = .temperature
	@Binding var currentLocation: CLLocation
	@Binding var navigationTitle: String
	
	@ObservedObject var locationManager = LocationManager.shared
	@ObservedObject var unitsManager = UnitsManager.shared
	var data: [LineGraphDate] = [
		// Day 1
		LineGraphDate(day: "2022-10-27", time: "00:00", temperature: 10.7, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "01:00", temperature: 12.7, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "02:00", temperature: 6, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "03:00", temperature: 5, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "04:00", temperature: 8, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "05:00", temperature: 10, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "06:00", temperature: 10, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "07:00", temperature: 10, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "08:00", temperature: 10.7, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "09:00", temperature: 10, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "10:00", temperature: 12.7, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "11:00", temperature: 12.7, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "12:00", temperature: 12.7, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "13:00", temperature: 12.7, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "14:00", temperature: 11, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "15:00", temperature: 11, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "16:00", temperature: 11, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "17:00", temperature: 11, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "18:00", temperature: 12.7, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "19:00", temperature: 12.7, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "20:00", temperature: 9, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "21:00", temperature: 9, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "22:00", temperature: 9, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-27", time: "23:00", temperature: 12.7, windSpeed: 9, rain: 0),
		// Day 2
		LineGraphDate(day: "2022-10-28", time: "00:00", temperature: 10.7, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "01:00", temperature: 16, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "02:00", temperature: 16, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "03:00", temperature: 16, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "04:00", temperature: 16, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "05:00", temperature: 14, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "06:00", temperature: 14, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "07:00", temperature: 14, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "08:00", temperature: 10.7, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "09:00", temperature: 14, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "10:00", temperature: 14, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "11:00", temperature: 14, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "12:00", temperature: 14, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "13:00", temperature: 14, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "14:00", temperature: 14, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "15:00", temperature: 9, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "16:00", temperature: 9, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "17:00", temperature: 9, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "18:00", temperature: 9, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "19:00", temperature: 6, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "20:00", temperature: 6, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "21:00", temperature: 6, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "22:00", temperature: 6, windSpeed: 9, rain: 0),
		LineGraphDate(day: "2022-10-28", time: "23:00", temperature: 6, windSpeed: 9, rain: 0)
	]
    // TODO: prepare data for charts
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
//                    dynamicHistoricalDataGraph(historicalHourly:  (historicalGraph.last?.historicalHourly ?? NSSet()) as! Set<HistoricalHourly>)
                    DatePicker(
                        selection: .constant(Date()),
                        displayedComponents: [.date],
                        label: { Text("Day 1") }
                    )
                    DatePicker(
                        selection: .constant(Date()),
                        displayedComponents: [.date],
                        label: { Text("Day 2") }
                    )
                    
                }
                .padding(.bottom, 30)
                Picker("Parameter", selection: $selectedParameter) {
                    Text("Temperature").tag(LineGraphParameter.temperature)
                    Text("Wind Speed").tag(LineGraphParameter.windSpeed)
                    Text("Rain").tag(LineGraphParameter.rain)
                }
                .pickerStyle(.segmented)
                Chart(data) {
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
				do {
					if !locationManager.locationBySearch {
						model.setLocation(location: locationManager.userLocation)
					} else {
						model.setLocation(location: currentLocation)
					}
					try await model.fetchApi(
						tempUnit: self.unitsManager.getCurrentUnit(),
						hourlyParameter: "temperature_2m"
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

//struct dynamicHistoricalDataGraph: View {
//    var historicalHourly: Set<HistoricalHourly>
//    var data: [LineGraphDate] = []
//    init(historicalHourly: Set<HistoricalHourly>) {
//        self.historicalHourly = historicalHourly
//
//            self.historicalHourly.forEach { element in
//                data.append(LineGraphDate(day: "\(element.time ?? Date().formatted(.dateTime.day(.defaultDigits).month(.defaultDigits).year(.defaultDigits)))",
//                                          time: "\(element.time ?? Date().formatted(.dateTime.day(.defaultDigits).month(.defaultDigits).year(.defaultDigits)))",
//                    temperature: element.temperature_2m,
//                    windSpeed: element.windspeed_10m,
//                    rain: element.rain))
//
//        }
//    }
//
//    var body: some View {
//        Text("")
//    }
//}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(currentLocation: .constant(CLLocation(latitude: 48.20849, longitude: 16.37208)), navigationTitle: .constant("Wien"))
    }
}
