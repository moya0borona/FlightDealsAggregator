//
//  Model.swift
//  FlightDealsAggregator
//
//  Created by Андрей Андриянов on 23.09.2025.
//

import Foundation

struct FlightData: Codable {
    let price: Double
    let airline: String
    let flight_number: Int
    let departure_at: String
    let return_at: String?
    let expires_at: String
}

struct Flight: Identifiable, Equatable {
    var id: String { "\(destination)-\(flightNumber)-\(departureAt)" }
    let destination: String
    let origin: String
    let price: Double
    let airline: String
    let flightNumber: Int
    let departureAt: Date
    let returnAt: Date?
    let expiresAt: Date
}

struct FlightMapper {
    static func map(destination: String, origin: String, dto: FlightData) -> Flight {
        Flight(
            destination: destination,
            origin: origin,
            price: dto.price,
            airline: dto.airline,
            flightNumber: dto.flight_number,
            departureAt: parseDate(dto.departure_at),
            returnAt: dto.return_at.flatMap(parseDate),
            expiresAt: parseDate(dto.expires_at)
        )
    }
    
    private static func parseDate(_ string: String) -> Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: string) ?? Date()
    }
}

struct APIResponse: Codable {
    let success: Bool
    let data: [String: [String: FlightData]]?
    let error: String?
}

