//
//  ImageState.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 03.01.2025.
//

import UIKit

enum ImageState {
    case empty
    case loading
    case success(UIImage)
    case failure(Error)
}
