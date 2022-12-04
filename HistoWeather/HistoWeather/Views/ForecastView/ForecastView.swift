//
//  ForecastView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 01.12.22.
//

import SwiftUI

struct Forecast: Identifiable {
    let id = UUID()
    let date: String
    let temperature: String
    let sfImageID: String
}


struct ForecastView: View {
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchDay(latitude: 0, longitude: 0),
                  animation: .default)
    private var day: FetchedResults<Day>
    
    
    @State private var model = ForecastViewModel()
    var body: some View {
        VStack{
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
            ScrollView {
                // Top Container
                
                Spacer()
                ForEach(day) { index in
                    HStack {
                        Text("\(index.time ?? Date())")
                        Spacer()
                        Text("\(index.temperature_2m_max)")
                            .fontWeight(.bold)
                            .fontWeight(.bold)
                        Image(systemName: index.weathericoncode ?? "wrench.fill")
                    }
                }
            }
            .refreshable {
                do{
                    try await model.fetchapi()
                } catch let error{
                    print("Error while refreshing friends: \(error)")
                }
            }
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}
