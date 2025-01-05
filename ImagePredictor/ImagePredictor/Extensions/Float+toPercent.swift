//
//  Image+uiImage.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 05.01.2025.
//

import Foundation

extension Float {
    func toPercent() -> String {
        let percent = Int(self * 100)
        return "\(percent)%"
    }
}
