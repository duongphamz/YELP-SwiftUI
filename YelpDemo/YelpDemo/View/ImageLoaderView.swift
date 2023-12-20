//
//  ImageLoaderView.swift
//  YelpDemo
//
//  Created by duongpham on 20/05/2023.
//

import SwiftUI

struct ImageLoaderView: View {
    @Binding var url: URL?
    var body: some View {
        if let url {
            AsyncImage(url: url, content: { image in
                image
                    .resizable()
                
            }, placeholder: {
                ProgressView()
                    .frame(width: 200, height: 200)
            })
            .frame(width: 200, height: 200)
        } else {
            ProgressView()
                .frame(width: 200, height: 200)
        }
    }
}

struct ImageLoaderView_Previews: PreviewProvider {
    static var previews: some View {
        ImageLoaderView(url: .constant(nil))
    }
}
