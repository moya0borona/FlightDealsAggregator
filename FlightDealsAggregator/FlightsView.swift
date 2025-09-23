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
                            
                            Button(action: {
                                viewModel.swapOriginDestination()
                            }) {
                                Image(systemName: "arrow.2.squarepath")
                                    .font(.system(size: 18))
                                    .padding()
                                    .background(Color.blue.opacity(0.2))
                                    .clipShape(Circle())
                            }
                        }
                        DatePicker("Дата вылета", selection: $viewModel.departDate, displayedComponents: .date)
                            .datePickerStyle(.compact)
                            .padding(.top, 8)
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom)
                    .background(Color.blue.opacity(0.3))
                    
                    Divider()
                    
                    Group {
                        if viewModel.isLoading {
                            ProgressView("Загрузка...")
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else if let error = viewModel.errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                        } else {
                            List(viewModel.flights) { flight in
                                NavigationLink(destination: FlightDetailView(flight: flight)) {
                                    FlightRow(flight: flight)
                                }
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                            .listStyle(.plain)
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
        }
    }
}

#Preview {
    FlightsView()
}

