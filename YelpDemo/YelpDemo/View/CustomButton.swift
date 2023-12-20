//
//  CustomButton.swift
//  YelpDemo
//
//  Created by duongpham on 20/05/2023.
//

import SwiftUI

struct CustomButton: View {
    let searchType: SearchType
    let width: CGFloat
    let height: CGFloat
    @Binding var selectedSearchType: SearchType
    var body: some View {
        Button(searchType.rawValue, action: {
            selectedSearchType = searchType
        })
        .frame(width: width, height: height)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(selectedSearchType == searchType ? .blue : .white, lineWidth: 1)
        )
        .foregroundColor(.black)
    }
}

struct BindingCustomButtonPreview: View {
    @State private var selectedSearchType: SearchType = .businessName
    var body: some View {
        CustomButton(searchType: .businessName, width: 150, height: 40, selectedSearchType: $selectedSearchType)
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        BindingCustomButtonPreview()
    }
}
