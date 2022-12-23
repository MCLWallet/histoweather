//
//  SearchView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 03.12.22.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @StateObject private var locationListVM = LocationListViewModel()
    @State private var searchText: String = ""
    @ObservedObject var networkChecker = NetworkChecker()
    @ObservedObject var locationManager = LocationManager.shared
	
    var body: some View {
        NavigationStack {
			ScrollView {
				ZStack {
					List(locationListVM.locations, id: \.id) { location in
						Button("\(location.name), \(location.country)") {
							Coordinates.coordinate = CLLocationCoordinate2D(latitude: location.latitude,
																			longitude: location.longitude)
							Coordinates.locationName = location.name
							searchText = ""
						}
					}
					.listStyle(.grouped)
					if !networkChecker.connected {
						VStack {
							Image(systemName: "wifi.slash")
								.resizable()
								.scaledToFit()
								.padding(.all)
								.frame(minWidth: 20, maxWidth: 100, minHeight: 20 )
							Text("checkInternet")
								.bold()
						}
					}
				}
				.navigationTitle("search")
			}
            
        }
        .searchable(text: $searchText, prompt: "typeInLocation")
        .onChange(of: searchText) { _ in runSearch(searchString: searchText)
        }
        .onSubmit(of: .search) {
            runSearch(searchString: searchText)
        }
    }
    func runSearch(searchString: String) {
        Task.init(operation: {
            if !searchString.isEmpty {
                await locationListVM.search(name: searchString)
            } else {
                locationListVM.locations.removeAll()
            }
        })
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
