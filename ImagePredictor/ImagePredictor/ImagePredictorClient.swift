//
//  ImagePredictorClient.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 03.01.2025.
//

import Dependencies

struct ImagePredictorClient {
    private let res: String

    func predict() -> String {
        res
    }
}

extension ImagePredictorClient: DependencyKey {
    static let liveValue = ImagePredictorClient(res: "qqq")
}
