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
            Text(date, style: .date)
                .padding()
            Spacer()
            Text("\(minTemp) \(maxTemp)")
            Spacer()
            Image(systemName: "cloud.sun")
                .padding()
        }
    }
}

#Preview {
    ForecastRowView(date: Date() , minTemp: 40, maxTemp: 80)
}

