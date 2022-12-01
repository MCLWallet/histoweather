//
//  CurrentView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 01.12.22.
//

import SwiftUI

struct CurrentView: View {
	var body: some View {
		VStack {
			// Top Container
			HStack {
				Spacer()
				// Date & Location View
				VStack(alignment: .trailing) {
					Text("vienna")
						.font(.largeTitle)
					Text("fakeDate")
						.font(.title3)
				}.padding()
			}
			Spacer()
			// Middle Container
			VStack {
				// Current Weather View
				Image(systemName: "cloud")
					.resizable()
					.frame(width: 150, height: 120)
				Text("fakeCurrentTemperature")
					.font(.largeTitle)
					.fontWeight(.light)
					.multilineTextAlignment(.center)
					.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
			}
			Spacer()
			// Humidity & Windspeed
			HStack {
				VStack(alignment: .leading) {
					Text("humidity")
					Text("fakeHumidity")
						.fontWeight(.bold)
				}.padding(.all)
				Spacer()
				VStack(alignment: .trailing) {
					Text("windSpeed")
					Text("fakeWindSpeed")
						.fontWeight(.bold)
				}.padding(.all)
			}
			// UV-Index & Rain
			HStack {
				VStack(alignment: .leading) {
					Text("uvIndex")
					Text("fakeUvIndex")
						.fontWeight(.bold)
				}.padding(.all)
				Spacer()
				VStack(alignment: .trailing) {
					Text("rain")
					Text("fakeRain")
						.fontWeight(.bold)
				}.padding(.all)
			}
		}
		
	}
}

struct CurrentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentView()
    }
}
