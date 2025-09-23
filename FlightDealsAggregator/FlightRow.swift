//
//  FlightRow.swift
//  FlightDealsAggregator
//
//  Created by Андрей Андриянов on 23.09.2025.
//

import SwiftUI

struct FlightRow: View {
    let flight: Flight
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("\(flight.origin) → \(flight.destination)")
                    .font(.headline)
                Text("Авиакомпания: \(flight.airline)")
                    .font(.caption)
                Text("Вылет: \(flight.departureAt)")
                    .font(.caption2)
            }
            Spacer()
            Text("\(Int(flight.price)) ₽")
                .bold()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    private var backgroundColor: Color {
        switch flight.price {
        case ..<10000:
            return Color.green.opacity(0.3)
        case 10000..<30000:
            return Color.yellow.opacity(0.3)
        default:
            return Color.red.opacity(0.3)
        }
    }
}
