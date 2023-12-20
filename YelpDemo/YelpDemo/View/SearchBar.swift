//
//  SearchBar.swift
//  YelpDemo
//
//  Created by duongpham on 20/05/2023.
//

import SwiftUI
import Combine

struct SearchBar: View {
    @Binding var text: String
    @State private var isEditing = false
    let textSubject: PassthroughSubject<String, Never>
    var body: some View {
        HStack {
            Rectangle()
                .fill(.gray)
                .frame(height: 50)
                .overlay(
                    TextField("Enter your keyword", text: $text)
                        .padding(8)
                        .padding(.horizontal, 25)
                        .background(Color(.white))
                        .cornerRadius(8)
                        .padding(.horizontal, 10)
                        .onReceive(Just(text), perform: { newValue in
                            textSubject.send(newValue)
                        })
                        .onTapGesture {
                            isEditing = true
                        }
                        .onSubmit {
                            isEditing = false
                        }
                        .overlay(alignment: .leading, content: {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                    .frame(width: 16, height: 16, alignment: .leading)
                                    .padding(.leading, 16)
                                if isEditing {
                                    Spacer()
                                    Button(action: {
                                        self.text = ""
                                    }) {
                                        Image(systemName: "multiply.circle.fill")
                                            .foregroundColor(.gray)
                                    }
                                    .frame(width: 16, height: 16, alignment: .trailing)
                                    .padding(.trailing, 16)
                                }
                            }
                            
                        })
                )
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(text: .constant("duong"), textSubject: PassthroughSubject<String, Never>())
    }
}

