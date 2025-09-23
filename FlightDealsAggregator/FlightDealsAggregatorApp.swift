//
//  FlightDealsAggregatorApp.swift
//  FlightDealsAggregator
//
//  Created by Андрей Андриянов on 23.09.2025.
//

import SwiftUI

@main
struct FlightDealsAggregatorApp: App {
    var body: some Scene {
        WindowGroup {
            FlightsView()
                .preferredColorScheme(.light)
        }
    }
}
