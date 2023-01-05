//
//  LocationManager.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 03.12.22.
//

import CoreLocation

class LocationManager: NSObject, ObservableObject {
	private let manager = CLLocationManager()
    @Published var userLocation: CLLocation? = CLLocation(latitude: 48.20849, longitude: 16.37208)
	@Published var userLocationCity: String = "Vienna"
	@Published var userLocationCountry: String = "Austria"
	@Published var authStatus: String?
	static let shared = LocationManager()
	
	override init() {
		super.init()
		manager.delegate = self
		manager.desiredAccuracy = kCLLocationAccuracyBest
		manager.startUpdatingLocation()
	}
	
	func requestLocation() {
		manager.requestWhenInUseAuthorization()
	}
}

extension LocationManager: CLLocationManagerDelegate {
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch manager.authorizationStatus {
		case .notDetermined:
			print("DEBUG: Not determined")
			authStatus = "notDetermined"
		case .restricted:
			print("DEBUG: Restricted")
			authStatus = "restricted"
		case .denied:
			print("DEBUG: Denied")
			authStatus = "denied"
		case .authorizedAlways:
			print("DEBUG: Auth always")
			authStatus = "authorizedAlways"
		case .authorizedWhenInUse:
			print("DEBUG: Auth when in use")
			authStatus = "authorizedWhenInUse"
		@unknown default:
			authStatus = "notDetermined"
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		self.userLocation = location
		
		let defaultLocationCoordinate = CLLocation(latitude: 48.20849, longitude: 16.37208)
		let defaultLocationName = "Vienna"
		let defaultLocationCountry = "Austria"
		
		CLGeocoder().reverseGeocodeLocation(self.userLocation ?? defaultLocationCoordinate, completionHandler: {(placemarks, error) in
			if error != nil {
				print("Error: \(String(describing: error))")
			} else {
				let placemark = CLPlacemark(placemark: (placemarks?[0] as CLPlacemark?)!)
				
				if placemark.country != nil {
					self.userLocationCountry = placemark.country ?? defaultLocationCountry
				}
				if placemark.name != nil {
					self.userLocationCity = placemark.name ?? defaultLocationName
				}
			}
		})
	}
}
