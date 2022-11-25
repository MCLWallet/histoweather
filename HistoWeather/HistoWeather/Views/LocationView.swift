//
//  LocationView.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 25.11.22.
//

import SwiftUI

struct LocationView: View {
    var body: some View {
        
        VStack {
            // Location & Date View
            HStack{
                Spacer()
                VStack(alignment: .trailing) {
                    Text("vienna")
                        .font(.largeTitle)
                    Text("fakeDate")
                        .font(.title3)
                }.padding()
            }
            VStack() {
                Image(systemName: "cloud")
                Text("fakeCurrentTemperature")
                    .font(.largeTitle)
                    .fontWeight(.light)
                    .multilineTextAlignment(.center)
                    .dynamicTypeSize(/*@START_MENU_TOKEN@*/.xxxLarge/*@END_MENU_TOKEN@*/)
            }
            Spacer()
            HStack {
                VStack {
                    Text("humidity")
                    Text("fakeHumidity")
                }
                Spacer()
                VStack {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Placeholder")/*@END_MENU_TOKEN@*/
                }
            }
        }
        
        
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
