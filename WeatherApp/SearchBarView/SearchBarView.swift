//
//  SearchBarView.swift
//

import SwiftUI

struct SearchBarView: View {
    @ObservedObject var vm: WeatherViewModel
    
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search", text: $vm.query)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    .onSubmit {
                        Task {
                            await vm.searchCity()
                        }
                    }
            }
        }
    }
}



#Preview {
    SearchBarView(vm: AppDIContainer.shared.makeWeatherViewModel())
}

