//
//  SliderView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 24.11.22.
//

import SwiftUI

struct SliderView: View {
    var body: some View {
        VStack(alignment: .trailing) {
            Text("hello")
                .font(.title)
                .foregroundColor(Color("BordeauxRed"))
                .multilineTextAlignment(.leading)
            Text("world")
                .font(.subheadline)
                .multilineTextAlignment(.leading)
        }
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SliderView()
        }
    }
}
