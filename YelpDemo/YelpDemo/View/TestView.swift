//
//  TestView.swift
//  YelpDemo
//
//  Created by duongpham on 21/11/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var scrollOffset: CGFloat = 0.0
    var items = [(value: 0, visible: false),
                 (value: 1, visible: false),
                 (value: 2, visible: false),
                 (value: 3, visible: false),
                 (value: 4, visible: false)]
    var body: some View {
        GeometryReader { reader in
            VStack {
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        ForEach(0..<5) { index in
                            Text("Item \(index)")
                                .frame(width: 200, height: 50)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                    }
                    .overlay(
                        GeometryReader { geo in
                            Color.clear
                            .onChange(of: geo.frame(in: CoordinateSpace.named("scrollView")), perform: { size in

                                print(size)
                            })
                        }
                    )
                    .padding()
                }
            }
            .coordinateSpace(name: "scrollView")
        }
    }
}

struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

