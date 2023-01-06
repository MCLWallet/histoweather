//
//  SliderView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 24.11.22.
//

import SwiftUI

struct SliderView: View {
    @State private var sliderValue: Double = 1999
	@State private var model = SliderViewModel()
	@State private var startDate = Calendar.current.date(byAdding: .year, value: -1, to: Date())!
	@State private var endDate = Date()
	
	let dateRange: ClosedRange<Date> = {
		let calendar = Calendar.current
		let startComponents = DateComponents(year: 1959, month: 1, day: 1)
		return calendar.date(from: startComponents)! ... Date()
	}()
	
	@State private var date = Date()
	
	@ObservedObject var unitsManager = UnitsManager.shared
	
    var body: some View {
		NavigationStack {
			ZStack {
                dynamicHistoricalData(date: Calendar.current.date(from: DateComponents(year: Int(sliderValue), month: 1, day: 1)) ?? Date())
				VStack {
					Spacer()
					Slider(
						value: $sliderValue,
                        in: 2000 ... 2022,
						label: {
//							Text("\(days[Int(round(sliderValue))])")
						}
					)
					.padding(.horizontal)
					HStack {
						DatePicker(
							selection: $startDate,
							in: dateRange,
							displayedComponents: [.date],
							label: { Text("Start Date") }
						)
						.labelsHidden()
						Spacer()
						DatePicker(
							selection: $endDate,
							in: dateRange,
							displayedComponents: [.date],
							label: { Text("End Date") })
						.labelsHidden()
					}
					.padding(.horizontal)
					.padding(.bottom)
				}
			}
			.navigationTitle(Coordinates.locationName)
			.foregroundColor(.hWBlack)
		}
		.onAppear {
			Task {
				do {
					try await model.fetchApi(unit: self.unitsManager.getCurrentTemperatureFullString())
				} catch let error {
					print("Error while refreshing weather: \(error)")
				}
			}
		}
    }
}

struct dynamicHistoricalData: View {
    @FetchRequest var day: FetchedResults<HistoricalDaily>
    
    init(date: Date) {
        let date1: Date = date
        let date2: Date = Calendar.current.date(byAdding: .day, value: 1, to: date1) ?? Date()
        
        _day = FetchRequest<HistoricalDaily>(entity: HistoricalDaily.entity(), sortDescriptors: [], predicate: NSPredicate(format: "%K >= %@ AND %K < %@", "time", date1 as NSDate, "time", date2 as NSDate))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: {
                if  self.day.first?.temperature_2m_max ?? -19 > 0.5 {
                    return [Color("BordeauxRed"), Color("VeryLightYellow")]
                } else {
                    return [Color("DarkBlue"), Color("VeryLightBlue")]
                }
            }()), startPoint: .topLeading,
               endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            VStack {
                Image(systemName: self.day.last?.weathericoncode ?? "wrench.fill")            // TODO: weathercode from History Weather API
                    .resizable()
                    .scaledToFit()
                    .padding(.all)
                    .frame(maxWidth: 250)
                Text("0 °C")                                                    // TODO: temperature from History Weather API
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                    .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
                HStack {
                    Text("high")
                    Text("\(self.day.last?.temperature_2m_max ?? 0)")                                                // TODO: max_temperature from History Weather API
                        .bold()
                    Text("low")
                    Text("\(self.day.last?.temperature_2m_min ?? 0)")                                                // TODO: min_temperature from History Weather API
                        .bold()
                }
                .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//			SliderView(days: ["", ""])

        }
    }
}
