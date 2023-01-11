//
//  SliderView.swift
//  HistoWeather
import SwiftUI
import CoreLocation

struct SliderView: View {
    @FetchRequest(fetchRequest: HistoricalWeatherPersistence.fetchAllHistoricalWeather(),
                  animation: .default)
    private var historicalWeather: FetchedResults<HistoricalWeather>
    @State private var sliderValue: Double = Double(Calendar.current.component(.year, from: Date()))
    @State private var model = SliderViewModel()
    @State private var startYear: Int = 1959
    @State private var endYear: Int = Calendar.current.component(.year, from: Date())
    let date: Date
    init() {
        let calendar = Calendar.current
        date = calendar.date(byAdding: .day, value: -6, to: Date())!
    }
	let dateRange: ClosedRange<Date> = {
		let calendar = Calendar.current
		let startComponents = DateComponents(year: 1959, month: 1, day: 1)
		return calendar.date(from: startComponents)! ... Date()
	}()
	
	@ObservedObject var unitsManager = UnitsManager.shared
	
    var body: some View {
        NavigationStack {
            ZStack {
                dynamicHistoricalData(date: Calendar.current.date(from: DateComponents(year: Int(sliderValue), month: Calendar.current.component(.month, from: date), day: Calendar.current.component(.day, from: date))) ?? Date())
                VStack(alignment: .leading) {
                    HStack {
                        Text("\(getSameDayWithDifferentYear(day: Calendar.current.component(.day, from: date), month:Calendar.current.component(.month, from: date) ,newYear: sliderValue).formatted(date: .abbreviated, time: .omitted))")
                            .font(.title3)
                    }
                    .padding(.leading)
                    Spacer()

                    .padding(.leading)
                    Spacer()
                    Slider(
                        value: $sliderValue,
                        in: Double(startYear) ... Double(endYear),
                        step: 1
                    )

                    .padding(.horizontal)
                    HStack {
                        Picker("", selection: $startYear) {
                            ForEach(1959...endYear - 1, id: \.self) {
                                Text(String($0))
                            }
                        }
                        .onChange(of: startYear, perform: { _ in
                            if sliderValue < Double(startYear) {
                                sliderValue = Double(startYear)
                            }
                        })
                        .pickerStyle(.menu)
                        Spacer()
                        Picker("", selection: $endYear) {
                            ForEach(startYear + 1...2023, id: \.self) {
                                Text(String($0))
                            }
                        }
                        .onChange(of: endYear, perform: { _ in
                            if sliderValue > Double(endYear) {
                                sliderValue = Double(endYear)
                            }
                        })
                        .pickerStyle(.menu)
                        
                    }
                    .padding(.horizontal)
                    .padding(.bottom)
                }
                
            }
            
            .navigationTitle(String((historicalWeather.last?.city ?? "nA") + ", " + (historicalWeather.last?.country ?? "nA")))
            .foregroundColor(.hWBlack)
        }

		.onAppear {
			Task {
				do {
                    try await model.fetchApi(unit: self.unitsManager.getCurrentTemperatureFullString(), startYear: startYear, endYear: endYear)
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
            
            VStack {

                Image(systemName: self.day.last?.weathericoncode ?? "wrench.fill")            // TODO: weathercode from History Weather API
                    .resizable()
                    .scaledToFit()
                    .padding(.all)
                    .frame(maxWidth: 250)
                HStack {
                    Text("high")
                    Text("\(self.day.last?.temperature_2m_max ?? 0)")                                                // TODO: max_temperature from History Weather API
                        .bold()
                    Text("low")
                    Text("\(self.day.last?.temperature_2m_min ?? 0)")                                                // TODO: min_temperature from History Weather API
                        .bold()
                }
                .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xLarge/*@END_MENU_TOKEN@*/)
            }
        }
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
			SliderView(currentLocation: .constant(CLLocation(latitude: 48.20849, longitude: 16.37208)), navigationTitle: .constant("Wien"))

        }
    }
}
