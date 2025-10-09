//
//  WeatherView.swift
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject private var vm = WeatherViewModel()
    
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
                    CurrentCardView(vm: vm)
                    Spacer()
                    ForecastHourlyView(vm: vm)
                    SevenDaysButtonView(title: "прогноз на 7 днів", action:  { vm.showSheetAction() })
                        .sheet(isPresented: $vm.showSheet) {
                            Forecast7DaysSheetView( vm: vm)
                        }
                    FavouriteCityButtonView(title: "збережені міста", action: {
                        Task {
                            await vm.saveCity(city: vm.city)
                            vm.addCity(city: vm.city)
                            vm.showSheetFavourites()
                        }
                    })
                    .sheet(isPresented: $vm.showSheetFvourites) {
                        FavouriteCityView(vm: vm)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
    }
}
    
    
    
    #Preview {
        WeatherView()
    }
