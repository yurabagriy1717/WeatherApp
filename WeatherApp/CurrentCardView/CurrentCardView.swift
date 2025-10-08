//
//  CurrentCardView.swift
//

import SwiftUI

struct CurrentCardView: View {
    @ObservedObject var vm: WeatherViewModel
    
    var body: some View {
        VStack() {
            if let url = vm.weatherIconURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: vm.imageName)
                        .font(.system(size: 160))
                        .symbolRenderingMode(.multicolor)
                        .padding()
            }
            
            Text(vm.city)
                .font(.title).bold()
                .foregroundStyle(Color.white)
            Text("\(vm.tempature)°C")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(Color.white)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .cornerRadius(16)
        .shadow(radius: 4, y: 2)
        
        VStack {
            Text(vm.description)
                .padding()
            
            HStack {
                Label("\(vm.feelsLike)" , systemImage: "thermometer")
                Spacer()
                Label("\(vm.windSpeed)" , systemImage: "wind")
                Spacer()
                Label("\(vm.humidity)" , systemImage: "humidity")
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
    CurrentCardView(vm: WeatherViewModel())
}


