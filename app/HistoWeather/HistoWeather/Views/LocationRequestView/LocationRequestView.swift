//
//  LocationRequestView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 03.12.22.
//

import SwiftUI

struct LocationRequestView: View {
	@ObservedObject var locationManager = LocationManager.shared
	
    var body: some View {
		VStack {
			Spacer()
			Image(systemName: "location.square.fill")
				.resizable()
				.scaledToFit()
				.frame(maxWidth: 150)
				.foregroundColor(Color("AccentColor"))
					.padding(.bottom, 20)
			Text("locationRequestTitle1")
				.font(.title2)
				.fontWeight(.bold)
				.multilineTextAlignment(.center)
				.padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
			Text("locationRequestTitle2")
				.font(.title3)
				.multilineTextAlignment(.center)
				.padding(/*@START_MENU_TOKEN@*/[.leading, .bottom, .trailing]/*@END_MENU_TOKEN@*/)
			Spacer()
			Button {
				LocationManager.shared.requestLocation()
			} label: {
				Text("allowLocationButtonText")
					.padding()
					.fontWeight(.bold)
					.foregroundColor(.white)
			}
			.frame(width: UIScreen.main.bounds.width)
			.padding(.horizontal, -32)
			.background(Color("AccentColor"))
			.clipShape(Capsule())
			Button {
				locationManager.authStatus = "maybeLater"
			} label: {
				Text("maybeLaterButtonText")
					.padding()
					.fontWeight(.bold)
			}
			Spacer()
		}
	}
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
