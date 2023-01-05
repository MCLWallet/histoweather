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
		return calendar.date(from: startComponents)! ... Date()
	}()
	
    var body: some View {
		NavigationStack {
			ScrollView {
				// 1. Pick two dates
				VStack {
					HStack {
						Text("1. Pick two dates")
							.font(.title2)
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
				
				// 2. Pick visualization style
				VStack {
					HStack {
						Text("2. Start exploring with Slider")
							.font(.title2)
							.fontWeight(.bold)
						Spacer()
					}
					NavigationLink(destination: {
						SliderView(days: daysBetween(startDate: startDate, endDate: endDate))

					}, label: {
						Label("Slider", systemImage: "slider.horizontal.2.gobackward")
							.font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
					})
					.frame(maxWidth: .infinity, minHeight: 400)
					.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
					.background(Color("VeryLightBlue"))
					.cornerRadius(20)
				}
				.padding(.all)
			}
//			.navigationTitle(Coordinates.locationName)
		}
    }
	
	func daysBetween(startDate: Date, endDate: Date) -> [String] {
	 var days: [String] = []

	 // Create a calendar to calculate the difference between the two dates
	 let calendar = Calendar.current

	 // Set the start and end dates to midnight to avoid including additional days
	 let start = calendar.startOfDay(for: startDate)
	 let end = calendar.startOfDay(for: endDate)

	 // Calculate the number of days between the two dates
	 let components = calendar.dateComponents([.day], from: start, to: end)

	 // Iterate over the number of days and add each day to the array
	 if let numDays = components.day {
		 for index in 0..<numDays {
			 let day = calendar.date(byAdding: .day, value: index, to: start)!
			 let dayFormatter = DateFormatter()
			 dayFormatter.dateFormat = "dd LLLL yyyy"
			 let dayString = dayFormatter.string(from: day)
			 days.append(dayString)
		 }
	 }

	 return days
 }
}

struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}
