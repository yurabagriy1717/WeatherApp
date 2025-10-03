//
//  SearchBarView.swift
//

import SwiftUI

struct SearchBarView: View {
    @State private var query: String = ""
    
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search", text: $query)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
        }
    }
}



#Preview {
    SearchBarView()
}
