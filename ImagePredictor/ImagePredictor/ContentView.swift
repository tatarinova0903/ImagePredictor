//
//  ContentView.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 03.01.2025.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

struct ContentView: View {
    let store: StoreOf<Feature>
    @State private var imageSelection: PhotosPickerItem? = nil

    var body: some View {
        VStack(spacing: 10) {
            SelectedImage(imageState: store.imageState)
                .padding(10)
            PhotosPicker(
                selection: $imageSelection,
                matching: .images
            ) {
                Text("Choose your image")
            }
        }
        .onChange(of: imageSelection) { _, newValue in
            store.send(.imageSelected(newValue))
        }
    }
}

#Preview {
    ContentView(
        store: Store(initialState: Feature.State()) {
            Feature()
        }
    )
}
