//
//  FlightsView.swift
//  FlightDealsAggregator
//
//  Created by Андрей Андриянов on 23.09.2025.
//

import SwiftUI
import Combine

struct FlightsView: View {
    @StateObject private var viewModel = FlightsViewModel()
    @State private var showCamera = false
    @State private var capturedImage: UIImage?
    @State private var showFlights = false
    @State private var isAnimating = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    VStack {
                        HStack {
                            VStack(spacing: 8) {
                                TextField("Откуда (IATA)", text: $viewModel.origin)
                                    .textFieldStyle(.roundedBorder)
                                    .textInputAutocapitalization(.characters)
                                
                                TextField("Куда (IATA)", text: $viewModel.destination)
                                    .textFieldStyle(.roundedBorder)
                                    .textInputAutocapitalization(.characters)
                            }
                            
                            Button(action: { viewModel.swapOriginDestination() }) {
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.system(size: 18))
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                        DatePicker("Дата вылета",
                                   selection: $viewModel.departDate,
                                   in: Date()...,
                                   displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom)
                    .background(Color.blue.opacity(0.3))
                    Spacer()
                    ZStack(alignment: .top) {
                        Color.clear.frame(height: 0)
                        if viewModel.isLoading {
                            ProgressView("Загрузка...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if !viewModel.flights.isEmpty {
                            ScrollView {
                                ZStack(alignment: .top) {
                                    let cellHeight: CGFloat = 80
                                    let spacing: CGFloat = 4
                                    
                                    ForEach(Array(viewModel.flights.prefix(10).enumerated()), id: \.1.id) { index, flight in
                                        NavigationLink(destination: FlightDetailView(flight: flight)) {
                                            FlightRow(flight: flight)
                                                .foregroundColor(.black)
                                                .background(Color.white)
                                                .cornerRadius(10)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .frame(height: cellHeight)
                                        .offset(y: showFlights ? CGFloat(index) * (cellHeight + spacing) : UIScreen.main.bounds.height)
                                        .zIndex(Double(10 - index))
                                        .animation(
                                            showFlights && index < 10
                                            ? .interpolatingSpring(stiffness: 120, damping: 22)
                                                .delay(Double(index) * 0.2)
                                            : .smooth(duration: 0.5),
                                            value: showFlights
                                        )
                                    }
                                    VStack(spacing: 4) {
                                        ForEach(viewModel.flights.dropFirst(10)) { flight in
                                            NavigationLink(destination: FlightDetailView(flight: flight)) {
                                                FlightRow(flight: flight)
                                                    .foregroundColor(.black)
                                                    .background(Color.white)
                                                    .cornerRadius(10)
                                            }
                                            .frame(height: cellHeight)
                                        }
                                    }
                                    .padding(.top, CGFloat(min(viewModel.flights.count, 10)) * (cellHeight + spacing))
                                }
                                .padding(12)
                            }
                        }
                        if isAnimating {
                            Color.clear
                                .contentShape(Rectangle())
                                .gesture(DragGesture())
                                .ignoresSafeArea()
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    Button(action: { showCamera.toggle() }) {
                        Image(systemName: "camera.viewfinder")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.black)
                    }
                    .fullScreenCover(isPresented: $showCamera) {
                        CameraView(image: $capturedImage)
                            .transition(.move(edge: .bottom))
                            .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showCamera)
                    }
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Поиск рейсов")
            .onChange(of: viewModel.flights) { _ in
                Task { await animateFlights() }
            }
        }
    }
    
    func animateFlights() async {
        guard !isAnimating else { return }
        isAnimating = true
        showFlights = false
        try? await Task.sleep(nanoseconds: 800_000_000)
        withAnimation {
            showFlights = true
        }
        try? await Task.sleep(nanoseconds: UInt64(1_000_000_000))
        isAnimating = false
    }
}



//#Preview {
//    FlightsView()
//}

