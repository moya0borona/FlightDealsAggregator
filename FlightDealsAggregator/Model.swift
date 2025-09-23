//
//  Model.swift
//  FlightDealsAggregator
//
//  Created by Андрей Андриянов on 23.09.2025.
//

import Foundation

struct Flight: Identifiable, Codable {
    var id: String { "\(destination)-\(flightNumber)-\(departureAt)" }
    let destination: String
    let origin: String 
    let price: Double
    let airline: String
    let flightNumber: Int
    let departureAt: String
    let returnAt: String?
    let expiresAt: String
}

struct FlightData: Codable {
    let price: Double
    let airline: String
    let flight_number: Int
    let departure_at: String
    let return_at: String?
    let expires_at: String
}

struct APIResponse: Codable {
    let success: Bool
    let data: [String: [String: FlightData]]?
    let error: String?
}
