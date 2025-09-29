//
//  FlightRepository.swift
//  FlightDealsAggregator
//
//  Created by Андрей Андриянов on 29.09.2025.
//

import Foundation

class FlightRepository {
    private let api: FlightAPI
    
    init(api: FlightAPI = FlightAPI()) {
         self.api = api
     }
    
    func getFlights(origin: String, destination: String, departDate: String?) async throws -> [Flight] {
        let response = try await api.fetchFlights(origin: origin, destination: destination, departDate: departDate)
        
        guard response.success, let data = response.data else {
            throw FlightError.apiError(response.error ?? "Неизвестная ошибка")
        }
        
        return data.flatMap { (destination, flightsMap) in
            flightsMap.map { (_, dto) in
                FlightMapper.map(destination: destination, origin: origin, dto: dto)
            }
        }.sorted { $0.price < $1.price }
    }
}


enum FlightError: Error, LocalizedError {
    case apiError(String)
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .apiError(let msg): return msg
        case .networkError: return "Ошибка сети"
        }
    }
}
