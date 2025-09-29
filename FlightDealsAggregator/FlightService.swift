//
//  FlightService.swift
//  FlightDealsAggregator
//
//  Created by Андрей Андриянов on 23.09.2025.
//

import Foundation


class FlightAPI {
    private let baseURL = "https://api.travelpayouts.com/v1/prices/cheap"
    private let token: String
    
    init(token: String = "321d6a221f8926b5ec41ae89a3b2ae7b") {
        self.token = token
    }
    
    func fetchFlights(origin: String, destination: String, departDate: String?) async throws -> APIResponse {
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
        
        var request = URLRequest(url: components.url!)
        request.setValue(token, forHTTPHeaderField: "X-Access-Token")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(APIResponse.self, from: data)
    }
}



