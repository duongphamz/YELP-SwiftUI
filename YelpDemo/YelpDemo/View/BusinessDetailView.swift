//
//  BusinessDetailView.swift
//  YelpDemo
//
//  Created by duongpham on 20/05/2023.
//

import SwiftUI

struct BusinessDetailView: View {
    let businessId: String
    @ObservedObject var viewModel = BusinessDetailViewModel()
    var body: some View {
        VStack {
            ImageLoaderView(url: $viewModel.imageUrl)
            List(viewModel.detailItems) { displayModel in
                HStack {
                    Text(displayModel.title)
                    Spacer()
                    Text(displayModel.description ?? "")
                }
            }
            .listStyle(.inset)
        }
        .task {
            await viewModel.fetchDetail(id: self.businessId)
        }
    }
}

struct BusinessDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessDetailView(businessId: "1")
    }
}
