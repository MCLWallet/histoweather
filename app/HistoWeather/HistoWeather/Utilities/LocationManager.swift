//
//  LocationManager.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 03.12.22.
//

import CoreLocation
// This is only used for getting user's coordinates
class LocationManager: NSObject, ObservableObject {
	private let manager = CLLocationManager()
    @Published var userLocation: CLLocation = CLLocation(latitude: 48.20849, longitude: 16.37208)
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
	
	func startUpdatingLocation() {
		manager.startUpdatingLocation()
	}
	func stopUpdatingLocation() {
		manager.stopUpdatingLocation()
	}
}

extension LocationManager: CLLocationManagerDelegate {
	func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
		switch manager.authorizationStatus {
		case .notDetermined:
			print("LocationManager: Not determined")
			authStatus = "notDetermined"
		case .restricted:
			print("LocationManager: Restricted")
			authStatus = "restricted"
		case .denied:
			print("LocationManager: Denied")
			authStatus = "denied"
		case .authorizedAlways:
			print("LocationManager: Auth always")
			authStatus = "authorizedAlways"
		case .authorizedWhenInUse:
			print("LocationManager: Auth when in use")
			authStatus = "authorizedWhenInUse"
		@unknown default:
			authStatus = "notDetermined"
		}
	}
	
	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		guard let location = locations.last else { return }
		self.userLocation = location
		
		print("LocationManager running ...")
		print("LocationManager lat: \(location.coordinate.latitude)")
		print("LocationManager long: \(location.coordinate.longitude)")
		
		manager.stopUpdatingLocation()
	}
}
