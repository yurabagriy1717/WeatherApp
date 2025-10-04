//
//  ForecastRowView.swift
//

import SwiftUI

struct ForecastRowView: View {
    
    let date: Date
    let minTemp: Int
    let maxTemp: Int
    
    var body: some View {
        HStack {
            Text(date, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated))
                .padding()
            Spacer()
            Text("\(minTemp)")
                .foregroundColor(.blue)
            Text("\(maxTemp)")
                .foregroundColor(.red)
            Spacer()
            Image(systemName: "cloud.sun")
                .padding()
        }
        .font(.headline)
    }
}

#Preview {
    ForecastRowView(date: Date() , minTemp: 40, maxTemp: 80)
}

