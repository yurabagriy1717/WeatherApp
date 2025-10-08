//
//  ForecastRowView.swift
//

import SwiftUI

struct ForecastRowView: View {
    let item: ForecastItem
    
    var body: some View {
        HStack {
            Text(formatDate(from: item.dt_txt))
                .fontWeight(.medium)
                .frame(width: 80, alignment: .leading)
            Spacer()
            Text("\(Int(item.main.temp_min))")
                .foregroundColor(.blue)
            Text("\(Int(item.main.temp_max))")
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
    ForecastRowView(item: ForecastItem(
            dt: 1661871600,
            main: ForecastMain(temp: 18, temp_min: 16, temp_max: 20),
            dt_txt: "2025-10-07 12:00:00",
            weather: [Weather(description: "Light rain", icon: "10d")]
    ))
}

