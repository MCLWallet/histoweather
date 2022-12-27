//
//  ForecastView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 01.12.22.
//

import SwiftUI

struct ForecastView: View {
    @FetchRequest(fetchRequest: DayWeatherPersistence.fetchDay(),
                  animation: .none)
    private var day: FetchedResults<Day>
    @State private var model = ForecastViewModel()
    
    var body: some View {
        NavigationView {
                ScrollView {
                    // Top Container
                    ForEach(day) { index in
                            HStack {
                                Text("\((index.time ?? Date()).formatted(.dateTime.weekday(.wide)))")
                                    .font(.title3)
                                    .fontWeight(.medium)
									.frame(minWidth: 150, alignment: .leading)
                                Spacer()
                                    Image(systemName: index.weathericoncode ?? "wrench.fill")
                                        .font(.title)
                                Text(String(format: "%.0f / %.0f", index.temperature_2m_min, index.temperature_2m_max))
                                    .font(.title2)
									.padding(.leading)
									.frame(minWidth: 80)
                            }
                            .padding(.all)
                            .background(.yellow)
                            .cornerRadius(20)
							.padding(.all, 10)
                    }
                }
                .onAppear {
                    Task {
                        do {
                            try await model.fetchApi()
                        } catch let error {
                            print("Error while refreshing friends: \(error)")
                        }
                    }
                }
                .refreshable {
                    do {
                        try await model.fetchApi()
                    } catch let error {
                        print("Error while refreshing friends: \(error)")
                    }
                }
				.navigationTitle(Coordinates.locationName)
        }
    }
}

struct ForecastView_Previews: PreviewProvider {
    static var previews: some View {
        ForecastView()
    }
}
