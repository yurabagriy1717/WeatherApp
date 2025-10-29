//
//  CurrentCardView.swift
//

import SwiftUI

struct CurrentCardView: View {
    @ObservedObject var vm: CurrentCardViewModel
    
    var body: some View {
        VStack() {
            if let url = vm.weatherDomainModel.iconURL {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 160, height: 160)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Image(systemName: "cloud.sun.fill")
                        .font(.system(size: 160))
                        .symbolRenderingMode(.multicolor)
                        .padding()
            }
            
            Text(vm.savedCityName)
                .font(.title).bold()
                .foregroundStyle(Color.white)
            Text("\(Int(vm.weatherDomainModel.temperature))°C")
                .font(.system(size: 40, weight: .bold))
                .foregroundStyle(Color.white)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .cornerRadius(16)
        .shadow(radius: 4, y: 2)
        
        VStack {
            Text(vm.weatherDomainModel.description)
                .padding()
            
            HStack {
                Label("\(vm.weatherDomainModel.feelsLike)" , systemImage: "thermometer")
                Spacer()
                Label("\(vm.weatherDomainModel.windSpeed)" , systemImage: "wind")
                Spacer()
                Label("\(vm.weatherDomainModel.humidity)" , systemImage: "humidity")
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
    CurrentCardView(vm: AppDIContainer.shared.makeCurrentCardViewModel())
}


