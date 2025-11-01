//
//  WeatherView.swift
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var vm = AppDIContainer.shared.makeWeatherViewModel()
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue, Color.cyan],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 16 ) {
                    SearchBarView(vm: vm)
                    CurrentCardView(vm: vm.currentCardVM)
                    Spacer()
                    ForecastHourlyView(vm: vm.forecastRowVM)
                    SevenDaysButtonView(title: "прогноз на 7 днів", action:  { vm.showSheetAction() })
                        .sheet(isPresented: $vm.showSheet) {
                            Forecast7DaysSheetView( vm: vm.forecastRowVM)
                        }
                    FavouriteCityButtonView(title: "збережені міста", action: {
                        vm.favouritesCityVM.addCity(city: vm.currentCardVM.savedCityName)
                        vm.showSheetFavourites()
                        
                    })
                    .sheet(isPresented: $vm.showSheetFvourites) {
                        FavouriteCityView(vm: vm.favouritesCityVM,                  onSelect: { city in
                            vm.query = city
                            Task {
                                await vm.searchCity()
                            }
                        })
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                if isLoading {
                    ZStack {
                        Color.black.opacity(0.3).ignoresSafeArea()
                        ProgressView("Завантаження...")
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                    }
                    .transition(.opacity.animation(.easeInOut(duration: 0.3)))
                }
            }
        }
        .task {
            await vm.currentCardVM.fetchCityWeather(city: vm.currentCardVM.savedCityName)
            await vm.forecastRowVM.fetchForecast(city: vm.currentCardVM.savedCityName)
        }
        .onReceive(vm.loadingPublisher) { value in
            withAnimation {
                isLoading = value
            }
        }
        .onReceive(vm.errorPublisher) { message in
            alertMessage = message
            showAlert = true
        }
        .alert("error", isPresented: $showAlert) {
            Button(role: .cancel) {
                alertMessage = ""
            } label: {
                Text("OK")
            }
        } message: {
            Text(alertMessage)
        }
    }
}



#Preview {
    WeatherView()
}
