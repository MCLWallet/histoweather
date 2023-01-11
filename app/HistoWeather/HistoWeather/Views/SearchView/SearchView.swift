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
	
    @State private var model = SearchViewModel()
    @State private var searchText: String = ""
    @ObservedObject var networkChecker = NetworkChecker()
    @ObservedObject var locationManager = LocationManager.shared
	@Binding var currentLocation: CLLocation
	@Binding var currentLocationName: String
	
	@State var lastSelectedTab = 1
	
    var body: some View {
		NavigationView {
			List {
				if (locationManager.authStatus == "authorizedAlways") ||
					(locationManager.authStatus == "authorizedWhenInUse") {
					Button(action: {
						currentLocation = locationManager.userLocation
						locationManager.locationBySearch = false
						dismiss()
					}, label: {
						Label("Your current location", systemImage: "location.fill")
					})
					.foregroundColor(.hWFontColor)
				}
				
				ForEach(model.locations, id: \.id) { location in
					Button("\(location.name), \(location.country)") {
						currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
						currentLocationName = location.name
						searchText = ""
						locationManager.locationBySearch = true
						dismiss()
					}
					.foregroundColor(.hWFontColor)
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
					.disabled((locationManager.authStatus != "authorizedAlways") &&
							  (locationManager.authStatus != "authorizedWhenInUse"))
					// TODO: Don't show when you're at beginning of app (no location yet)
				}
//				ToolbarItem(placement: .confirmationAction) {
//					Button("Done") {
//						dismiss()
//					}
//					// TODO: Disable when there is no location yet
//				}
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
		SearchView(currentLocation: .constant(CLLocation(latitude: 48.20849, longitude: 16.37208)), currentLocationName: .constant("Wien"))
    }
}
