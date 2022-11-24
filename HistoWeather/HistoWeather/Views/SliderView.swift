//
//  SliderView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 24.11.22.
//

import SwiftUI

struct SliderView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var body: some View {
        Text("hello")
            .font(.largeTitle)
            .multilineTextAlignment(.leading)
    }
}

struct SliderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SliderView()
//            SliderView()
//                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}
