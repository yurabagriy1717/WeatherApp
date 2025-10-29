//
//  FavouriteCityView.swift
//

import SwiftUI

struct FavouriteCityView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: FavouriteCityViewModel
    var onSelect: (String) -> Void
    
    var body: some View {
        NavigationStack {
            Text("favourites city")
                .font(.title2)
                .padding(.top)
            List {
                ForEach(vm.favouriteCity, id: \.self) { city in
                    Button {
                        onSelect(city)
                        dismiss()
                    } label: {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.blue)
                            Text(city)
                                .font(.headline)
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding(.vertical, 6)
                    }
                }
                .onDelete(perform: vm.removeCity)
            }
            .listStyle(.insetGrouped)
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
    FavouriteCityView(vm: AppDIContainer.shared.makeFavouriteCityViewModel()) { _ in }
}
