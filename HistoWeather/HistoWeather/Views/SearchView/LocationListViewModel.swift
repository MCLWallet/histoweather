//
//  LocationListViewModel.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 04.12.22.
//

import Foundation

@MainActor
class LocationListViewModel: ObservableObject {
	
	@Published var locations: [LocationViewModel] = []
	
	func search(name: String) async {
		do {
			let locations = try await LocationSearchWebservice().getLocations(searchTerm: name)
			self.locations = locations.map(LocationViewModel.init)
		} catch {
			print(error)
		}
	}
}

struct LocationViewModel {
	
	let location: Location
	
	var id: Int {
		location.id
	}
	
	var name: String {
		location.name
	}
	
	var longitude: Double {
		location.longitude
	}
	
	var latitude: Double {
		location.latitude
	}
}
