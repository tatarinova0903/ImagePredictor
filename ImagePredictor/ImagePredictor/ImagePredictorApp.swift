//
//  ImagePredictorApp.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 03.01.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct ImagePredictorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                store: Store(initialState: Feature.State()) {
                    Feature()
                }
            )
        }
    }
}
