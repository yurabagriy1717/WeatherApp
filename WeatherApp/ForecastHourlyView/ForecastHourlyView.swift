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
    
    let hourlyData: [HourlyWeather] = [
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,
        HourlyWeather(temp: 23, symbol: "cloud.rain.fill", time: "10:00") ,

    ]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(hourlyData) { hour in
                    VStack {
                        Text("\(hour.temp)")
                        Image(systemName:hour.symbol)
                        Text("\(hour.time)")
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
    ForecastHourlyView()
}
