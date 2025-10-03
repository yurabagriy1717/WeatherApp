//
//  WeatherView.swift
//

import SwiftUI

struct WeatherView: View {
    
    @State private var showSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.blue, Color.cyan],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(alignment: .center, spacing: 16 ) {
                    SearchBarView()
                    CurrentCardView(city: "Kyiv", tempature: 20, feelsLike: 23, description: "gresf", windSpeed: 24, humidity: 12)
                    Spacer()
                    SevenDaysButtonView(title: "прогноз на 7 днів", action:  { showSheet = true })
                        .sheet(isPresented: $showSheet) {
                            Forecast7DaysSheetView()
                        }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
        }
    }
}



#Preview {
    WeatherView()
}
