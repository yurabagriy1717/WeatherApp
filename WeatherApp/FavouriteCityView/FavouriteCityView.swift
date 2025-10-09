//
//  FavouriteCityView.swift
//

import SwiftUI

struct FavouriteCityView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: WeatherViewModel

    var body: some View {
        NavigationStack {
            Text("favourites city")
                .font(.title2)
                .padding(.top)
            List {
                ForEach(vm.favouriteCity, id: \.self) { city in
                    Text(city)
                }
                .onDelete(perform: vm.removeCity)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .font(.title2)
                            .foregroundColor(.black)
                    }
                    
                }
            }
        }
    }
}


#Preview {
    FavouriteCityView(vm: WeatherViewModel())
}
