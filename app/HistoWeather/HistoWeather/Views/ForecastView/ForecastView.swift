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
        VStack {
            HStack {
                // Date & Location View
                VStack(alignment: .leading) {
                    Text("vienna")
                        .font(.largeTitle)
                    Text("\((day.first?.time ?? Date()).formatted(date: .complete, time: .omitted))")
                        .font(.title3)
                }.padding()
				Spacer()
            }
            ScrollView {
                // Top Container
                Spacer()
                ForEach(day) { index in
                    HStack(alignment: .center) {
                        HStack {
                            Text("\((index.time ?? Date()).formatted(date: .complete, time: .omitted))")
                                .font(.title3)
                                .fontWeight(.medium)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(String(format: "%.1f / %.1f", index.temperature_2m_min, index.temperature_2m_max))
                                    .font(.title2)
                            }
                            .padding(.trailing)
                            Image(systemName: index.weathericoncode ?? "wrench.fill")
                                .font(.title)
                        }
                        .padding(.all)
                    }
                    .background(.red)
                    .cornerRadius(20)
                    .padding(10)

                }
            }
            .onAppear {
                Task {
                    do {
                        try await model.fetchapi()
                    } catch let error {
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
