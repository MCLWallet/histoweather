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
    
    @State var showError: Bool = false
    
    var body: some View {
		NavigationView {
			List {
					Button(action: {
                        if (locationManager.authStatus != "authorizedAlways") &&
                                (locationManager.authStatus != "authorizedWhenInUse") {
                            locationManager.requestLocation()
                        } else {
                            currentLocation = locationManager.userLocation
                            locationManager.locationBySearch = false
                            dismiss()
                        }
					}, label: {
						Label("Your current location", systemImage: "location.fill")
					})
					.foregroundColor(.hWFontColor)
				
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
            .alert("alert-title-error", isPresented: $showError, actions: { // Show an alert if an error appears
                Button("ok", role: .cancel) {
                    // Do nothing
                }
            }, message: {
                Text("alert-message-error")
            })
			.navigationTitle("search")
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button("Cancel") {
						dismiss()
					}
					.disabled((locationManager.authStatus != "authorizedAlways") &&
							  (locationManager.authStatus != "authorizedWhenInUse"))
				}

			}
		}
    }
    
    func runSearch(searchString: String) {
        Task.init(operation: {
            if !searchString.isEmpty {
                do {
                   try await model.search(name: searchString)
                } catch let error {
                    print("\(error)")
                    showError = true
                }
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
