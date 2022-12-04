//
//  SearchView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 03.12.22.
//

import SwiftUI

struct SearchView: View {
	@State private var searchText = ""
    var body: some View {
		NavigationStack {
			Text("typeInLocation")
				.font(.largeTitle)
				.fontWeight(.bold)
				.foregroundColor(Color("DarkBlue"))
				.multilineTextAlignment(.center)
				
		}
		.searchable(text: $searchText, prompt: "Look for something")
		.onSubmit(of: .search) {
			print($searchText.self.wrappedValue)
		}
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
