//
//  SliderView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 24.11.22.
//

import SwiftUI

struct SliderView: View {
	@State private var sliderValue: Double = 0
	@State private var model = SliderViewModel()
	@State var days: [String]
	@ObservedObject var unitsManager = UnitsManager.shared
	
    var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: {
				if sliderValue > Double(days.count-1) / 2 {
					return [Color("BordeauxRed"), Color("VeryLightYellow")]
				} else {
					return [Color("DarkBlue"), Color("VeryLightBlue")]
				}
			}()), startPoint: .topLeading,
			   endPoint: .bottomTrailing)
				.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
			VStack {
				Spacer()
				Text("\(days[Int(round(sliderValue))])")
				Slider(value: $sliderValue, in: 0 ... Double(days.count-1))
					.padding(.all)
			}
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

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
			SliderView(days: ["12-2-2022", "13-2-2022"])
        }
    }
}
