//
//  ContentView.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 03.01.2025.
//

import SwiftUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<Feature>

    var body: some View {
        VStack {
            Text("\(store.image)")
            Button("Choose your image") {
                store.send(.imageSelected)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView(
        store: Store(initialState: Feature.State()) {
            Feature()
        }
    )
}
