//
//  Location.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 04.12.22.
//

import Foundation

struct LocationResponse: Decodable {
	let locations: [Location]
	
	private enum CodingKeys: String, CodingKey {
		case locations = "results"
	}
}

struct Location: Decodable {
	let id: Int
	let name: String
    let country: String
	let latitude: Double
	let longitude: Double
}
