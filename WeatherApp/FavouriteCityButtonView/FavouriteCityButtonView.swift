//
//  FavouriteCityButtonView
//

import SwiftUI

struct FavouriteCityButtonView: View {
    
    
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
    FavouriteCityButtonView(title: "hello", action: { print("прогноз на 7 днів") })
}

