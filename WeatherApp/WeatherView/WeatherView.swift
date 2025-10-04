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
                    CurrentCardView(city: vm.city, tempature: vm.tempature, feelsLike: vm.feelsLike, description: vm.description, windSpeed: vm.windSpeed, humidity: vm.humidity, imageName: vm.imageName)
                    Spacer()
                    ForecastHourlyView()
                    SevenDaysButtonView(title: "прогноз на 7 днів", action:  { vm.showSheetAction() })
                        .sheet(isPresented: $vm.showSheet) {
                            Forecast7DaysSheetView()
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
