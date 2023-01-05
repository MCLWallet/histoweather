//
//  GraphView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 28.12.22.
//

import SwiftUI
import Charts

struct LineGraphDate: Identifiable {
	var id: UUID
	
	var day: String									// represents line
	var time: Date									// x-axis
	var temperature: Double							// y-axis
	var windSpeed: Double							// y-axis
	var rain: Double								// y-axis
	
	init(day: String, time: String, temperature: Double, windSpeed: Double, rain: Double) {
		let timeFormat = DateFormatter()
		timeFormat.dateFormat = "HH:mm"
		
		self.day = day
		self.time = timeFormat.date(from: time)!
		self.temperature = temperature
		self.windSpeed = windSpeed
		self.rain = rain
		self.id = UUID()
	}
}

enum LineGraphParameter: String, CaseIterable, Identifiable {
	case temperature, windSpeed, rain
	var id: Self { self }
}

struct GraphView: View {
	@State private var selectedParameter: LineGraphParameter = .temperature
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
	
    var body: some View {
		NavigationStack {
			ScrollView {
				HStack {
					Text("Pick 2 days to compare ")
						.font(.title2)
						.fontWeight(.bold)
					Spacer()
				}
				VStack {
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
//			.navigationTitle(Coordinates.locationName)
			.padding(.all)
		}
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
