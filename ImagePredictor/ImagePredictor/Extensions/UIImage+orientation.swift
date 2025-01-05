//
//  UIImage+.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 05.01.2025.
//

import UIKit

extension UIImage {
    var cgImageOrientation: CGImagePropertyOrientation? {
        CGImagePropertyOrientation(rawValue: UInt32(imageOrientation.rawValue))
    }
}
