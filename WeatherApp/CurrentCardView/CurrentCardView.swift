//
//  CurrentCardView.swift
//

import SwiftUI

struct CurrentCardView: View {
    
    let city: String
    let tempature: Int
    let feelsLike: Int
    let description: String
    let windSpeed: Int
    let humidity: Int
    let imageName: String
    
    var body: some View {
        VStack() {
            Image(systemName: imageName)
                .font(.system(size: 160))
                .symbolRenderingMode(.multicolor)
                .padding()
            Text(city)
                .font(.title).bold()
                .foregroundStyle(Color.white)
            Text("\(tempature)°C")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(Color.white)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .cornerRadius(16)
        .shadow(radius: 4, y: 2)
        
        VStack {
            Text(description)
                .padding()
            
            HStack {
                Label("\(feelsLike)" , systemImage: "thermometer")
                Spacer()
                Label("\(windSpeed)" , systemImage: "wind")
                Spacer()
                Label("\(humidity)" , systemImage: "humidity")
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial)
        .cornerRadius(16)
        .shadow(radius: 4, y: 2)
    }
}



#Preview {
    CurrentCardView(city: "Kyiv", tempature: 37, feelsLike: 42, description: "weather is sunny 34% snow", windSpeed: 100, humidity: 80, imageName: "gbrg")
}


