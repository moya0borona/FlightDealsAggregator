//
//  FlightDetailView.swift
//  FlightDealsAggregator
//
//  Created by Андрей Андриянов on 23.09.2025.
//

import SwiftUI

struct FlightDetailView: View {
    let flight: Flight
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("\(flight.origin) → \(flight.destination)")
                .font(.largeTitle)
                .bold()
                .foregroundColor(titleColor)
            
            Text("Цена: \(Int(flight.price)) ₽")
                .foregroundColor(priceColor)
            
            Text("Авиакомпания: \(flight.airline)")
            
            if let returnAt = flight.returnAt {
                Text("Возврат: \(returnAt)")
            }
            Divider()
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(backgroundColor)
                .padding(.horizontal, 8)
        )
    }
    
    private var titleColor: Color {
        flight.price < 10000 ? .green : .primary
    }
    
    private var priceColor: Color {
        flight.price > 30000 ? .red : .primary
    }
    
    private var backgroundColor: Color {
        flight.price < 10000 ? Color.green.opacity(0.1) :
        flight.price > 30000 ? Color.red.opacity(0.1) : Color.yellow.opacity(0.1)
    }
}

