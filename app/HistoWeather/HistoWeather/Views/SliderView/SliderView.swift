//
//  SliderView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 24.11.22.
//

import SwiftUI

struct SliderView: View {
	@State private var sliderValue: Double = 0.5
	@State private var model = SliderViewModel()
	
    var body: some View {
		ZStack {
			LinearGradient(gradient: Gradient(colors: [Color("BordeauxRed"), Color("VeryLightYellow")]), startPoint: .topLeading, endPoint: .bottomTrailing)
				.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
			VStack {
				Spacer()
				Slider(value: $sliderValue)
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

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SliderView()
        }
    }
}
