//
//  Object.swift
//  TestTaskNumbers
//
//  Created by Viacheslav Tolstopianteko on 16.10.2022.
//

import Foundation
import RealmSwift

final class NumberFactRealm: Object, ObjectKeyIdentifiable {
	@Persisted(primaryKey: true) var _id: ObjectId
	@Persisted var addedDate = Date()
	@Persisted var text: String = ""
	@Persisted var number: Int = 0
	@Persisted var found: Bool = false
}
