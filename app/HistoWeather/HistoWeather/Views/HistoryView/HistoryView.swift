//
//  HistoryView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 28.12.22.
//

import SwiftUI
// TODO: Localize this UI
struct HistoryView: View {
	@State private var startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
	@State private var endDate = Date()
	
	let dateRange: ClosedRange<Date> = {
		let calendar = Calendar.current
		let startComponents = DateComponents(year: 1959, month: 1, day: 1)
		return calendar.date(from: startComponents)!
			...
			Date()
	}()
	
    var body: some View {
		NavigationStack {
			ScrollView {
				VStack {
					HStack {
						Text("1. Pick two dates")
							.font(.title)
							.fontWeight(.bold)
						Spacer()
					}
					// TODO: StartDate cannot be after EndDate
					DatePicker(
						selection: $startDate,
						in: dateRange,
						displayedComponents: [.date],
						label: { Text("Start Date") }
					)
					// TODO: EndDate cannot be before StartDate
					DatePicker(
						selection: $endDate,
						in: dateRange,
						displayedComponents: [.date],
						label: { Text("End Date") })
				}
				.padding(.all)
				VStack {
					HStack {
						Text("2. Pick a visualization style")
							.font(.title)
							.fontWeight(.bold)
						Spacer()
					}
					NavigationLink(destination: {
						GraphView()
					}, label: {
						Label("Graph", systemImage: "chart.xyaxis.line")
							.font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
					})
					.frame(maxWidth: .infinity, minHeight: 180)
					.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
					.background(Color("VeryLightBlue"))
					.cornerRadius(20)
					.padding(.bottom, 10)
					NavigationLink(destination: {
						SliderView()
					}, label: {
						Label("Slider", systemImage: "slider.horizontal.2.gobackward")
							.font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
					})
					.frame(maxWidth: .infinity, minHeight: 180)
					.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
					.background(Color("VeryLightBlue"))
					.cornerRadius(20)
				}
				.padding(.all)
			}
			.navigationTitle("History")
		}
    }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
