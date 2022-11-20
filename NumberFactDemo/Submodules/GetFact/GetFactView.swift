//
//  ContentView.swift
//  TestTaskNumbers
//
//  Created by Viacheslav Tolstopianteko on 15.10.2022.
//

import SwiftUI
import RealmSwift

private struct Strings {
	@Localizable static var yourNumber 				= "YOUR_NUMBER"
	@Localizable static var getFactNumber 			= "GET_FACT_NUMBER"
	@Localizable static var getFactRandomNumber 	= "GET_FACT_RANDOM_NUMBER"
	@Localizable static var enterTheNumber			= "ENTER_THE_NUMBER"
	@Localizable static var ok						= "OK"
	@Localizable static var error					= "ERROR"
}

struct GetFactView: View {
	
	private let websercive = Webservice()
	
	@ObservedResults(NumberFactRealm.self, sortDescriptor: SortDescriptor(keyPath: "addedDate", ascending: false)) var numberFacts
	
	@State private var inputNumber: String = ""
	@State private var showingAlert = false
	@State private var goToDetails = false
	@State private var detailsItem: NumberFactRealm = NumberFactRealm()
	@State private var cancelableTasks: [Task<(), Never>] = Array.init()
	@State private var showError = false
	@State private var errorMessage = ""

	var body: some View {
		NavigationView {
			VStack {
				// Details Link
				detailsLink()
				// Text Field
				buildTextField(placehorlder: Strings.$yourNumber)
				// Get fact by number
				buildButton(title: Strings.$getFactNumber) {
					if let number = Int(inputNumber) { loadNumberFact(value: number) }
					else { showingAlert = true }
					inputNumber = ""
				}.alert(Strings.$enterTheNumber,
						isPresented: $showingAlert) { Button(Strings.$ok, role: .cancel) {} }
				// Get fact by random number
				buildButton(title: Strings.$getFactRandomNumber) { loadNumberFact(random: true) }
				// List of number facts
				buildList()
			}.onDisappear {
				cancelableTasks.forEach({$0.cancel()})
				cancelableTasks = Array.init()
			}
		}.alert(Strings.$error, isPresented: $showError,
				actions: { Button(Strings.$ok, role: .cancel) {} },
				message: { Text(errorMessage) })
	}
	
	@ViewBuilder
	private func detailsLink() -> some View {
		NavigationLink(isActive: $goToDetails) { FactDetails(item: detailsItem)
		} label: { Label.init(title: {}, icon: {}) }
	}
	
	@ViewBuilder
	private func buildTextField(placehorlder: String) -> some View {
		TextField(placehorlder, text: $inputNumber)
			.textFieldStyle(RoundedBorderTextFieldStyle())
			.frame(width: UIScreen.main.bounds.width * 0.8, alignment: .center)
			.textContentType(.creditCardNumber)
			.multilineTextAlignment(.center)
			.padding()
			.font(.title)
	}
	
	@ViewBuilder
	private func buildButton(title: String, action: @escaping () -> Void) -> some View {
		Button(action: action, label: {
			Text(title)
				.font(.headline)
				.fontWeight(.medium)
				.multilineTextAlignment(.center)
				.padding()
				.background(Color.accentColor)
				.foregroundColor(Color.white)
				.cornerRadius(10)
		})
	}
	
	@ViewBuilder
	private func buildList() -> some View {
		List {
			ForEach(numberFacts) { item in GetFactItemRow(item: item) }
			.onDelete(perform: $numberFacts.remove)
		}
	}
	
	private func loadNumberFact(value: Int? = nil, random: Bool = false) {
		let task = Task {
			do {
				if let value = value {
					let fact = try await websercive.load(NumberFact.byNumber(value)).mapToRealmObject()
					recieve(fact: fact)
				} else if random {
					let fact = try await websercive.load(NumberFact.byRandomNumber).mapToRealmObject()
					recieve(fact: fact)
				}
			} catch {
				errorMessage = error.localizedDescription
				showError = true
			}
		}
		cancelableTasks.append(task)
	}
	
	private func recieve(fact: NumberFactRealm) {
		$numberFacts.append(fact)
		goToDetails = true
		detailsItem = fact
	}
}
