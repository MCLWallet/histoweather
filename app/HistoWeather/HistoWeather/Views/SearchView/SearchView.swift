//
//  SearchView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 03.12.22.
//

import SwiftUI
import MapKit

struct SearchView: View {
	@Environment(\.dismiss) var dismiss
	
    @StateObject private var model = SearchViewModel()
    @State private var searchText: String = ""
    @ObservedObject var networkChecker = NetworkChecker()
    @ObservedObject var locationManager = LocationManager.shared
	
	@State var lastSelectedTab = 1
	
    var body: some View {
		NavigationView {
			List {
				ForEach(model.locations, id: \.id) { location in
					Button("\(location.name), \(location.country)") {
						Coordinates.coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
						Coordinates.locationName = location.name
						searchText = ""
						dismiss()
					}
				}
			}
			.searchable(text: $searchText, prompt: "typeInLocation")
			.onChange(of: searchText) { _ in runSearch(searchString: searchText)
			}
			.onSubmit(of: .search) {
				runSearch(searchString: searchText)
			}
			.navigationTitle("search")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") {
						dismiss()
					}
				}
				ToolbarItem(placement: .confirmationAction) {
					Button("Done") {
						dismiss()
					}
				}
			}
		}
    }
    func runSearch(searchString: String) {
		print("searchString: \(searchString)")
        Task.init(operation: {
            if !searchString.isEmpty {
                await model.search(name: searchString)
            } else {
                model.locations.removeAll()
            }
        })
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
