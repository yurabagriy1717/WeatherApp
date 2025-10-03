//
//  Forecast7DaysSheet.swift
//

import SwiftUI

struct Forecast7DaysSheetView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach (0..<7) { day in
                        ForecastRowView(
                            date: Date().addingTimeInterval(Double(day) * 86400),
                            minTemp: 77 ,
                            maxTemp: 42)
                        .listRowBackground(Color.clear)
                        .background(.thinMaterial)
                        .cornerRadius(14)
                    }
                }
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
    Forecast7DaysSheetView()
}
