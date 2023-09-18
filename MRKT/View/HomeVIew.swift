//
//  HomeVIew.swift
//  MRKT
//
//  Created by Irakli Vashakidze on 16.09.23.
//

import SwiftUI
import Foundation

struct GridItemView: View {
    let size: Double
    let item: Photo

    var body: some View {
        VStack {
            AsyncImage(url: item.nsURL) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }
            .frame(width: size, height: size - 20)
            Text(item.author)
                .foregroundColor(.black)
        }
    }
}

struct HomeView: View {
    
    @ObservedObject private(set) var loginVM : UserViewModel
    @StateObject private var dataModel = HomeViewModel()
    
    private static let initialColumns = 3
    @State private var gridColumns = Array(repeating: GridItem(.flexible()),
                                           count: initialColumns)
    @State private var numColumns = initialColumns
    
    private var columnsTitle: String {
        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    LazyVGrid(columns: gridColumns) {
                        ForEach(dataModel.items) { item in
                            GeometryReader { geo in
                                NavigationLink(destination: DetailView(item: item)) {
                                    GridItemView(size: geo.size.width, item: item)
                                }
                            }
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                    .padding()
                }
                Spacer()
                LoadingButton(loading: false, title: "Log out", enabled: true, action: {
                    loginVM.logout()
                }).frame(width: 120, height: 54, alignment: .center)
            }
            .navigationBarTitle("Photos")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}



