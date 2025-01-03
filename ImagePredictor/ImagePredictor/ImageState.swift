//
//  ImageState.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 03.01.2025.
//

import SwiftUI

enum ImageState {
    case empty
    case loading
    case success(Image)
    case failure(Error)
}
