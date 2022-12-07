//
//  ForecastView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 01.12.22.
//

import SwiftUI

struct ForecastView: View {
    
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchDay(),
                  animation: .default)
    private var day: FetchedResults<Day>
    
    @State private var model = ForecastViewModel()
    
    var body: some View {
        VStack {
            HStack {
                // Date & Location View
                VStack(alignment: .leading) {
                    Text("vienna")
                        .font(.largeTitle)
                    Text("fakeDate")
                        .font(.title3)
                }.padding()
				Spacer()
            }
            
            ScrollView {
                // Top Container
                Spacer()
                ForEach(day) { index in
                    HStack {
                        Text("\(index.time?.ISO8601Format() ?? Date().ISO8601Format())")
                        Spacer()
                        VStack(alignment: .trailing){
                            Text(String(format: "min: %.1f",index.temperature_2m_min))
                                .fontWeight(.bold)
                                .fontWeight(.bold)
                            Text(String(format: "max: %.1f",index.temperature_2m_max))
                                .fontWeight(.bold)
                                .fontWeight(.bold)
                            
                        }
                        Image(systemName: index.weathericoncode ?? "wrench.fill")
                    }
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
            .refreshable {
                do {
                    try await model.fetchapi()
                } catch let error {
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
