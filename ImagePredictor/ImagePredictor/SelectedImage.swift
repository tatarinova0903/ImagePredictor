//
//  SelectedImage.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 03.01.2025.
//

import Foundation
import SwiftUI

struct SelectedImage: View {
    let imageState: ImageState

    var body: some View {
        switch imageState {
        case .success(let uiImage):
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFit()
        case .loading:
            ProgressView()
        case .empty:
            Image(systemName: "photo")
                .font(.system(size: 40))
        case .failure:
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
        }
    }
}
