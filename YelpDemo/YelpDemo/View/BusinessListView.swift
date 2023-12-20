//
//  ContentView.swift
//  YelpDemo
//
//  Created by duongpham on 14/05/2023.
//

import SwiftUI
import Combine

enum SearchType: String {
    case businessName = "Business name"
    case location = "Location"
    case cuisineType = "Cuisine type"
}

struct BusinessListView: View {
    
    @ObservedObject var viewModel = BusinessListViewModel()
    @State private var keyword: String = ""
    @State private var searchType: SearchType = .businessName
    
    var body: some View {
        NavigationView() {
            VStack {
                SearchBar(text: $keyword, textSubject: viewModel.searchTextSubject)
                Text("Search by:")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                GeometryReader { proxy in
                    let spacing: CGFloat = 8 * 4
                    let buttonWidth = (proxy.size.width - spacing) / 3
                    let buttonHeight: CGFloat = 40
                    HStack {
                        CustomButton(searchType: .businessName, width: buttonWidth, height: buttonHeight, selectedSearchType: $searchType)
                        CustomButton(searchType: .location, width: buttonWidth, height: buttonHeight, selectedSearchType: $searchType)
                        CustomButton(searchType: .cuisineType, width: buttonWidth, height: buttonHeight, selectedSearchType: $searchType)
                    }
                    .lineSpacing(8)
                    .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                }
                .frame(height: 40)

                List(viewModel.businesses) { business in
                    HStack {
                        NavigationLink(destination: BusinessDetailView(businessId: business.objectID)) {
                            AsyncImage(url: URL(string: business.imageUrl!), content: { image in
                                image.resizable()
                            }, placeholder: {
                                ProgressView()
                            })
                            .frame(width: 50, height: 50)
                            VStack {
                                Text(business.name ?? "")
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
        }
        .onChange(of: searchType, perform: { type in
            viewModel.searchTypeSubject.send(type)
        })
        .onAppear {
            viewModel.startUpdatingLocation()
        }
        .onDisappear {
            viewModel.stopUpdatingLocation()
        }
    }
}

struct BusinessListView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessListView()
    }
}
