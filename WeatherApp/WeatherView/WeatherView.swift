//
//  WeatherView.swift
//

import SwiftUI

struct WeatherView: View {
    @StateObject private var vm = AppDIContainer.shared.makeWeatherViewModel()
    
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
            }
        }
        .task {
            await vm.currentCardVM.fetchCityWeather(city: vm.currentCardVM.savedCityName)
            await vm.forecastRowVM.fetchForecast(city: vm.currentCardVM.savedCityName)
        }
    }
}
    
    
    
    #Preview {
        WeatherView()
    }
