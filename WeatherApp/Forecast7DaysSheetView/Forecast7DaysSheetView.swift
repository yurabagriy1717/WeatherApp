//
//  Forecast7DaysSheet.swift
//

import SwiftUI

struct Forecast7DaysSheetView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: WeatherViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(vm.dailyForecast) { item in
                        ForecastRowView(item: item)
                        
                    }
                }
                .listRowBackground(Color.clear)
                .background(.thinMaterial)
                .cornerRadius(14)
                .scrollContentBackground(.hidden)
                .background(
                    LinearGradient(
                        colors: [Color.blue, Color.cyan],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    Forecast7DaysSheetView(vm: WeatherViewModel())
}
