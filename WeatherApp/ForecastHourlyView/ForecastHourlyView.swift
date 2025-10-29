//
//  ForecastHourlyView.swift
//

import SwiftUI


struct HourlyWeather: Identifiable {
    let id = UUID()
    let temp: Int
    let symbol: String
    let time: String
    
}

struct ForecastHourlyView: View {
    @ObservedObject var vm: ForecastRowViewModel

        
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(vm.hourlyForecast) { hour in
                    VStack {
                        Text("\(Int(hour.temperatureInfo.temp))°C")
                        Text(vm.formatHour(from: hour.forecatDays))
                    }
                    .foregroundColor(.white)
                    .frame(width: 70, height: 110)
                    .background(Color.white.opacity(0.15))
                    .cornerRadius(16)
                    .shadow(radius: 2, y: 1)
                }
            }
        }
    }
}


#Preview {
    ForecastHourlyView(vm: AppDIContainer.shared.makeForecastRowViewModel())
}
