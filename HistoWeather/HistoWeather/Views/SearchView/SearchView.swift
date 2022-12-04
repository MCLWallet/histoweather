//
//  SearchView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 03.12.22.
//

import SwiftUI

struct SearchView: View {
	@StateObject private var locationListVM = LocationListViewModel()
	@State private var searchText: String = ""
	@ObservedObject var networkChecker = NetworkChecker()
	
    var body: some View {
		NavigationStack {
			ZStack {
				List(locationListVM.locations, id: \.id) { location in
					Text("\(location.name): \(location.longitude), \(location.latitude)")
				}
				.listStyle(.grouped)
				if !networkChecker.connected {
					VStack {
						Image(systemName: "wifi.slash")
							.resizable()
							.scaledToFit()
							.padding(.all)
							.frame(minWidth: 20, maxWidth: 100, minHeight: 20 )
						Text("checkInternet")
							.bold()
					}
				}
			}
		}
		.searchable(text: $searchText, prompt: "typeInLocation")
		.onChange(of: searchText) { _ in runSearch(searchString: searchText)
		}
		.onSubmit(of: .search) {
			runSearch(searchString: searchText)
		}
    }
	func runSearch(searchString: String) {
		Task.init(operation: {
			if !searchString.isEmpty {
				await locationListVM.search(name: searchString)
			} else {
				locationListVM.locations.removeAll()
			}
		})
	}
}


struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
