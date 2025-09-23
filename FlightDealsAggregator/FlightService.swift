//
//  FlightService.swift
//  FlightDealsAggregator
//
//  Created by Андрей Андриянов on 23.09.2025.
//

import Foundation

class FlightService {
    private let baseURL = "https://api.travelpayouts.com/v1/prices/cheap"
    private let token: String
    
    init(token: String = "321d6a221f8926b5ec41ae89a3b2ae7b") {
        self.token = token
    }
    
    func fetchFlights(
        origin: String,
        destination: String = "-",
        departDate: String? = nil
    ) async throws -> [Flight] {
        
        let url = buildURL(origin: origin, destination: destination, departDate: departDate)
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-Access-Token")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        
        guard apiResponse.success, let responseData = apiResponse.data else {
            throw NSError(
                domain: "FlightService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: apiResponse.error ?? "Ошибка API"]
            )
        }
        return parseFlights(from: responseData, origin: origin)
    }
    
    private func buildURL(origin: String, destination: String, departDate: String?) -> URL {
        var components = URLComponents(string: baseURL)!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "origin", value: origin),
            URLQueryItem(name: "destination", value: destination),
            URLQueryItem(name: "currency", value: "RUB")
        ]
        if let departDate = departDate {
            queryItems.append(URLQueryItem(name: "depart_date", value: departDate))
        }
        components.queryItems = queryItems
        return components.url!
    }
    
    private func parseFlights(from data: [String: [String: FlightData]], origin: String) -> [Flight] {
        var flights: [Flight] = []
        
        for (destination, flightsMap) in data {
            for (_, flightData) in flightsMap {
                flights.append(
                    Flight(
                        destination: destination,
                        origin: origin,
                        price: flightData.price,
                        airline: flightData.airline,
                        flightNumber: flightData.flight_number,
                        departureAt: flightData.departure_at,
                        returnAt: flightData.return_at,
                        expiresAt: flightData.expires_at
                    )
                )
            }
        }
        return flights.sorted { $0.price < $1.price }
    }
}


