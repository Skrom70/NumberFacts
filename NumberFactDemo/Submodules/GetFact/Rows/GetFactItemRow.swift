//
//  ItemRow.swift
//  TestApp
//
//  Created by Viacheslav Tolstopianteko on 18.10.2022.
//

import Foundation
import SwiftUI
import RealmSwift

struct GetFactItemRow: View {
	@ObservedRealmObject var item: NumberFactRealm
	var body: some View {
		NavigationLink(destination: FactDetails(item: item)) {
			Text(item.text)
				.lineLimit(1)
				.foregroundColor(item.found ? .black : .red)
		}
	}
}


