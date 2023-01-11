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
    
    private let startDate = DateComponents(calendar: Calendar.current, year: 1959, month: 1, day: 2).date  ?? Date()
    @State private var model = GraphViewModel()
    @State private var dayOne: Date = DateComponents(calendar: Calendar.current, year: 1959, month: 1, day: 2).date  ?? Date()
    @State private var dayTwo: Date = getDateByDaysAdded(from: Date(), daysAdded: -7)
    @State private var selectedParameter: LineGraphParameter = .temperature
    @State private var lineGraphData: [LineGraphDate] = []
    @Binding var currentLocation: CLLocation
    @Binding var navigationTitle: String
    @ObservedObject var locationManager = LocationManager.shared
    @ObservedObject var unitsManager = UnitsManager.shared
    
    @State var showError = false
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    DatePicker(
                        selection: $dayOne,
                        in: startDate...(Calendar.current.date(byAdding: .day, value: -1, to: dayTwo) ?? Date()),
                        displayedComponents: [.date],
                        label: { Text("dayOne") }
                    )
                    .onChange(of: dayOne, perform: { _ in
                        Task {
                            await reloadValues()
                        }
                    })
                    DatePicker(
                        selection: $dayTwo,
                        in: (Calendar.current.date(byAdding: .day, value: +1, to: dayOne) ?? Date())...(Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date()),
                        displayedComponents: [.date],
                        label: { Text("dayTwo") }
                        
                    )
                    .onChange(of: dayTwo, perform: { _ in
                        Task {
                            await reloadValues()
                        }
                    })
                }
                .padding(.bottom, 30)
                Picker("parameter", selection: $selectedParameter) {
                    Text("temperature").tag(LineGraphParameter.temperature)
                    Text("windSpeed").tag(LineGraphParameter.windSpeed)
                    Text("rain").tag(LineGraphParameter.rain)
                }

                .pickerStyle(.segmented)
                if selectedParameter == .temperature {
                    Chart(lineGraphData) {
                        LineMark(
                            x: .value("hours", $0.time),
                            y: .value("temperature", $0.temperature)
                        )
                        .foregroundStyle(by: .value("Day", $0.day))
                    }
                    .chartYAxisLabel(unitsManager.currentTemperatureUnit.rawValue)
                    .frame(minHeight: 420)
                    .padding(.all)
                } else if selectedParameter == .windSpeed {
                    
                    Chart(lineGraphData) {
                        LineMark(
                            x: .value("hours", $0.time),
                            y: .value("windSpeed", $0.windSpeed)
                        )
                        .foregroundStyle(by: .value("day", $0.day))
                    }
                    .chartYAxisLabel("km/h")
                    .frame(minHeight: 420)
                    .padding(.all)
                } else if selectedParameter == .rain {
                    Chart(lineGraphData) {
                        LineMark(
                            x: .value("hours", $0.time),
                            y: .value("rain", $0.rain)
                        )
                        .foregroundStyle(by: .value("day", $0.day))
                    }
                    .chartYAxisLabel("mm")
                    .frame(minHeight: 420)
                    .padding(.all)
                }
            }
            .alert("alert-title-error", isPresented: $showError, actions: { // Show an alert if an error appears
                Button("ok", role: .cancel) {
                    // Do nothing
                }
            }, message: {
                Text("alert-message-error")
            })
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        unitsManager.changeCurrentTemperatureUnit()
                        Task {
                            await reloadValues()
                        }
                    }, label: {
                        Text("\(unitsManager.currentTemperatureUnit.rawValue)")
                            .font(.title)
                    })
                    .foregroundColor(.hWFontColor)
                }
            }
            .navigationTitle(navigationTitle)
            .padding(.all)
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
                startDate: (Calendar.current.date(byAdding: .day, value: +1, to: dayOne) ?? Date()),
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
                        newLineGraphData.append(
                            LineGraphDate(
                                day: getDayString(from: (item as AnyObject).time ?? Date()),
                                time: getTimeString(from: (item as AnyObject).time ?? Date()),
                                temperature: (item as AnyObject).temperature_2m,
                                windSpeed: (item as AnyObject).windspeed_10m,
                                rain: (item as AnyObject).rain)
                        )
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
