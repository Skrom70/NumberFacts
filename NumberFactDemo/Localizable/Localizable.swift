//
//  Localizable.swift
//  WeatherApp
//
//  Created by Viacheslav Tolstopianteko on 13.11.2022.
//

import Foundation

@propertyWrapper
struct Localizable {
	private(set) var key: String
	private var arguments: [CVarArg] = []
	
	private(set) var projectedValue: String
	
	var wrappedValue: String {
		get { return key }
		set {
			projectedValue = String(format: NSLocalizedString(key, comment: ""), arguments: [])
		}
	}
	
	init(wrappedValue: String) {
		self.key = wrappedValue
		self.projectedValue = String(format: NSLocalizedString(key, comment: ""), arguments: arguments)
	}
	
	init(wpareedValue: String, arguments: CVarArg...) {
		self.key = wpareedValue
		self.arguments = arguments
		self.projectedValue = String(format: NSLocalizedString(key, comment: ""), arguments: arguments)
	}
}
