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
//    @State private var startDate: Date
//    @State private var endDate: Date
//    @State private var dayMonth: Date
    
    
    var body: some View {
		ZStack {
            dynamicHistoricalData(date: Calendar.current.date(from: DateComponents(year: Int(sliderValue), month: 1, day: 1)) ?? Date())

			VStack {
                Spacer()
                Slider(value: $sliderValue, in: 1999...2022, step: 1.0)
                .padding(.all)

			}
		}
		.onAppear {
			Task {
				do {
					try await model.fetchApi()
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
            
            VStack{
                Text("Max Temp: \(self.day.first?.temperature_2m_max ?? 0)")
                Text("Max Temp: \(self.day.first?.time ?? Date())")
                Text("City: \(self.day.first?.historicalWeather?.city ?? "Missing")")
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
