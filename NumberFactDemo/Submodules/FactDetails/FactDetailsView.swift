//
//  FactDetailsView.swift
//  TestTaskNumbers
//
//  Created by Viacheslav Tolstopianteko on 19.11.2022.
//

import Foundation
import SwiftUI
import RealmSwift

struct FactDetails: View {
	@ObservedRealmObject var item: NumberFactRealm
	var body: some View {
		VStack {
			Text(String(item.number))
				.multilineTextAlignment(.center)
				.padding()
				.font(.title)
				.foregroundColor(item.found ? .black : .red)
			Text(item.text)
				.multilineTextAlignment(.center)
				.padding()
				.foregroundColor(item.found ? .black : .red)
		}
	}
}
