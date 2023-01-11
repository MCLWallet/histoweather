//
//  LocationListViewModel.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 04.12.22.
//

import Foundation
import CoreLocation

@MainActor
class SearchViewModel: ObservableObject {
    
    @Published var locations: [LocationViewModel] = []
    private let dayWeatherRepository: DayWeatherRepository

    init(dayWeatherRepository: DayWeatherRepository = DayWeatherRepository()) {
        self.dayWeatherRepository = dayWeatherRepository
    }
	
	func search(name: String) async throws {
			let locations = try await LocationSearchWebservice().getLocations(searchTerm: name)
			self.locations = locations.map(LocationViewModel.init)
	}
    
	func setLocation(location: CLLocation) {
		print("SearchViewModel setLocation: \(location.coordinate.latitude), \(location.coordinate.longitude)")
		dayWeatherRepository.updateLocation(location: location)
    }
	
	func setLocationTitle(locationName: String) {
		dayWeatherRepository.updateLocationTitle(locationTitle: "\(locationName)")
	}
	
	func getLocationTitle() -> String {
		return dayWeatherRepository.locationTitle
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
    var country: String {
        location.country
    }
	var latitude: Double {
		location.latitude
	}
}
