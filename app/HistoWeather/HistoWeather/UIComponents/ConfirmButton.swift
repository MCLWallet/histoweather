//
//  ConfirmButton.swift
//  HistoWeather
//
//  Created by Marcell Lanczos on 28.12.22.
//

import SwiftUI

//struct ConfirmButton: View {
//	@State var label: String
//	@Binding var action: () -> Void = { print("Test") }()
//	@Binding var view: AnyView?
//	
//    var body: some View {
//		if view != nil {
//			NavigationLink(destination: view) {
//				Text(label)
//					.padding()
//					.fontWeight(.bold)
//					.foregroundColor(.white)
//			}
//			.frame(width: UIScreen.main.bounds.width)
//			.padding(.horizontal, -32)
//			.background(Color("AccentColor"))
//			.clipShape(Capsule())
//		} else if action != nil {
//			Button(action: {
//				self.action ?? {print("Test")}
//			}
//)
//			{
//				Text(label)
//					.padding()
//					.fontWeight(.bold)
//					.foregroundColor(.white)
//			}
//			.frame(width: UIScreen.main.bounds.width)
//			.padding(.horizontal, -32)
//			.background(Color("AccentColor"))
//			.clipShape(Capsule())
//		}
//    }
//}
//
//struct ConfirmButton_Previews: PreviewProvider {
//	let testAction: () -> Void = {
//		print("ConfirmButton was tapped")
//	}
//    static var previews: some View {
//		ConfirmButton(label: "String", action: {
//			print("ConfirmButton was tapped")
//		}
//		)
//    }
//}
