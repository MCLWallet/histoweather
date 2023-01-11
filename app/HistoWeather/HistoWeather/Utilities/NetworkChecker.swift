//
//  NetworkChecker.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 04.12.22.
//

import Foundation
import Network

class NetworkChecker: NSObject, ObservableObject {
    public static let shared = NetworkChecker()
	let monitor = NWPathMonitor()
	let queue = DispatchQueue(label: "Monitor")
	@Published var connected: Bool = false
	override init() {
        super.init()
		monitor.pathUpdateHandler = { path in
			DispatchQueue.main.async {
				self.connected = path.status == .satisfied
			}
		}
		monitor.start(queue: queue)
	}
}
