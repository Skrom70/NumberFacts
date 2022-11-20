//
//  NumberFact.swift
//  TestTaskNumbers
//
//  Created by Viacheslav Tolstopianteko on 16.10.2022.
//

import Foundation

protocol NumberFactMapping {
	func mapToRealmObject() -> NumberFactRealm
}

struct NumberFact: Codable {
	let text: String
	let number: Int?
	let found: Bool
}


extension NumberFact: NumberFactMapping {
	func mapToRealmObject() -> NumberFactRealm {
		let obj = NumberFactRealm()
		obj.text = self.text
		obj.number = self.number ?? 0
		obj.found = found
		return obj
	}
}

extension NumberFact {
	static func byNumber(_ value: Int) -> Resource<NumberFact> {
		guard let url = URL.forNumberFact(value) else {
			fatalError("value = \(value) was not found.")
		}
		return Resource(url: url)
	}
	
	static var byRandomNumber: Resource<NumberFact> {
		return Resource(url: URL.forRandomNumberFact)
	}
}

extension URL {
	static func forNumberFact(_ value: Int) -> URL? {
		URL(string: "http://numbersapi.com/\(value)?json")!
	}
	
	static var forRandomNumberFact: URL {
		URL(string: "http://numbersapi.com/random/math?json")!
	}
}

