//
//  SevenDaysButtonView.swift
//

import SwiftUI

struct SevenDaysButtonView: View {
    
    
    
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
        }
        .buttonStyle(.borderedProminent)

    }
}

#Preview {
    SevenDaysButtonView(title: "hello", action: { print("прогноз на 7 днів") })
}

