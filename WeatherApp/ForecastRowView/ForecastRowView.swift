//
//  ForecastRowView.swift
//

import SwiftUI

struct ForecastRowView: View {
    let item: ForecastItemModel
    
    var body: some View {
        HStack {
            Text(formatDate(from: item.forecatDays))
                .fontWeight(.medium)
                .frame(width: 80, alignment: .leading)
            Spacer()
            Text("\(Int(item.temperatureInfo.temp_min))")
                .foregroundColor(.blue)
            Text("\(Int(item.temperatureInfo.temp_max))")
                .foregroundColor(.red)
            Spacer()
            if let url = item.iconURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                } placeholder : {
                    ProgressView()
                        .frame(width: 32, height: 32)
                }
            }
        }
        .font(.headline)
    }
    
    private func formatDate(from text: String) -> String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = formatter.date(from: text) {
                formatter.dateFormat = "E"
                return formatter.string(from: date)
            }
            return text
        }
}

#Preview {
    ForecastRowView(item: ForecastItemModel(
        date: 1661871600,
        temperatureInfo: TempratureInfoModel(temp: 18, temp_min: 16, temp_max: 20),
        forecatDays: "2025-10-07 12:00:00",
        weatherInfo: [
            WeatherInfoModel(description: "Light rain", icon: "10d")
        ]
    ))
}
