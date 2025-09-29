//
//  ViewModel.swift
//  FlightDealsAggregator
//
//  Created by Андрей Андриянов on 23.09.2025.
//

import SwiftUI
import Combine

@MainActor
class FlightsViewModel: ObservableObject {
    @Published var flights: [Flight] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil
    @Published var origin: String = "MOW"
    @Published var destination: String = ""
    @Published var departDate: Date = Date()
    
    private let repository: FlightRepository
    
    init(repository: FlightRepository = FlightRepository()) {
        self.repository = repository
        setupBindings()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func setupBindings() {
        Publishers.CombineLatest3($origin, $destination, $departDate)
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .sink { [weak self] origin, destination, date in
                Task { await self?.searchFlights(origin: origin, destination: destination, departDate: date) }
            }
            .store(in: &cancellables)
    }
    
    func searchFlights(origin: String, destination: String, departDate: Date) async {
        guard origin.count == 3 else { return }
        
        isLoading = true
        errorMessage = nil
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: departDate)
        
        do {
            let result = try await repository.getFlights(
                origin: origin.uppercased(),
                destination: destination.isEmpty ? "-" : destination.uppercased(),
                departDate: dateString
            )
            flights = result
        } catch {
            flights = []
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func swapOriginDestination() {
        let temp = origin
        origin = destination
        destination = temp
    }
}



