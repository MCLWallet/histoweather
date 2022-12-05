//
//  CurrentView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 01.12.22.
//

import SwiftUI
import MapKit

struct WeatcherIcon: Identifiable {
	let id = UUID()
	let weatherCode: [Int16]
	let description: String
	let sfImageID: String
}

struct CurrentView: View {
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchDayWeather(latitude: 0, longitude:0),
                  animation: .default)
    private var dayWeather: FetchedResults<DayWeather>
	// TODO: message to Milos: I left this merge conflict intentionally because not sure if we are using dayWeather or day? Line 115 & 121 still use day variable
<<<<<<< HEAD
    
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchDay(latitude: 0, longitude: 0),
                  animation: .default)
    private var day: FetchedResults<Day>
    

=======
	
	@ObservedObject var locationManager = LocationManager.shared
	
>>>>>>> location_feature
    @State private var model = ForecastViewModel()
	var body: some View {
		let coordinate = self.locationManager.userlocation != nil
		? self.locationManager.userlocation!.coordinate : CLLocationCoordinate2D()

		return ScrollView {
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
                Image(systemName:dayWeather.last?.weathericoncode ?? "wrench.fill")
					.resizable()
					.frame(width: 150, height: 120)
				Text("\(dayWeather.last?.temperature ?? 0.0)°C")
					.font(.largeTitle)
					.fontWeight(.light)
					.multilineTextAlignment(.center)
					.padding(.bottom)
					.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
				HStack {
					Text("high")
					Text("\(day.first?.temperature_2m_max ?? 0)")
						.bold()
					Text("low")
					Text("\(day.first?.temperature_2m_min ?? 0)")
						.bold()
				}
				.dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
				// Debug Log Coordinates
				Text("\(coordinate.latitude), \(coordinate.longitude)")
			}
            .refreshable {
                do{
                    try await model.fetchapi()
                } catch let error{
                    print("Error while refreshing friends: \(error)")
                }
            }
			Spacer()
			// Humidity & Windspeed
			HStack {
				VStack(alignment: .leading) {
					Text("elevation")
					Text("\(dayWeather.last?.elevation ?? 0.0)")
						.fontWeight(.bold)
				}.padding(.all)
				Spacer()
                VStack(alignment: .trailing) {
                    Text("precipitation")
                    Text("\(day.first?.precipitation_sum ?? 0)")
                        .fontWeight(.bold)
                }.padding(.all)
			}
            HStack {
                VStack(alignment: .leading) {
                    Text("winddirection")
                    Text("\(dayWeather.last?.winddirection ?? 0.0)")
                        .fontWeight(.bold)
                }.padding(.all)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("windSpeed")
                    Text("\(dayWeather.last?.windspeed ?? 0.0)")
                        .fontWeight(.bold)
                }.padding(.all)
            }
            HStack {
                VStack(alignment: .leading) {
                    Text("sunrise")
                    Text("\(day.first?.sunrise ?? Date())")
                        .fontWeight(.bold)
                }.padding(.all)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("sunset")
                    Text("\(day.first?.sunset ?? Date())")
                        .fontWeight(.bold)
                }.padding(.all)
            }
		}
        .refreshable {
            do{
                try await model.fetchapi()
            } catch let error{
                print("Error while refreshing friends: \(error)")
            }
        }
        .onAppear {
            Task{
                do{
                    try await model.fetchapi()
                } catch let error{
                    print("Error while refreshing friends: \(error)")
                }
            }
		}
	}
}

struct CurrentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentView()
    }
}
