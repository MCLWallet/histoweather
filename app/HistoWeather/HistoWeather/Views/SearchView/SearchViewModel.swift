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
	
	func search(name: String) async {
		do {
			let locations = try await LocationSearchWebservice().getLocations(searchTerm: name)
			self.locations = locations.map(LocationViewModel.init)
		} catch {
			print(error)
		}
	}
    
    func setLocation(latitude: Double, longitude: Double) {
        dayWeatherRepository.location = CLLocation(latitude: latitude, longitude: longitude)
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
