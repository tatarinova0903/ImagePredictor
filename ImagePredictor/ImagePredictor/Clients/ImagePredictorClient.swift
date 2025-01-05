//
//  ImagePredictorClient.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 03.01.2025.
//

import ComposableArchitecture
import Vision
import UIKit

typealias ImagePredictionHandler = (_ predictions: [Prediction]?) -> Void

final class ImagePredictorClient {
    private let imageClassifierVisionModel: VNCoreMLModel

    init() {
        let defaultConfig = MLModelConfiguration()

        guard let imageClassifier = try? Flowers(configuration: defaultConfig) else {
            fatalError("App failed to create an image classifier model instance.")
        }

        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifier.model) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }

        self.imageClassifierVisionModel = imageClassifierVisionModel
    }

    private var predictionHandlers = [VNRequest: ImagePredictionHandler]()

    func makePredictions(for photo: UIImage) async throws -> [Prediction] {
        try await withCheckedThrowingContinuation { continuation in
            let orientation = photo.cgImageOrientation ?? .up
            guard let photoImage = photo.cgImage else { fatalError("Photo doesn't have underlying CGImage.") }

            let imageClassificationRequest = VNCoreMLRequest(
                model: imageClassifierVisionModel,
                completionHandler: visionRequestHandler
            )
            imageClassificationRequest.imageCropAndScaleOption = .centerCrop

            predictionHandlers[imageClassificationRequest] = { predictions in
                continuation.resume(returning: predictions ?? [])
            }

            let handler = VNImageRequestHandler(cgImage: photoImage, orientation: orientation)
            let requests: [VNRequest] = [imageClassificationRequest]

            do {
                try handler.perform(requests)
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }

    private func visionRequestHandler(_ request: VNRequest, error: Error?) {
        guard let predictionHandler = predictionHandlers.removeValue(forKey: request) else {
            fatalError("Every request must have a prediction handler.")
        }

        var predictions: [Prediction]? = nil

        defer {
            predictionHandler(predictions)
        }

        if let error = error {
            print("Vision image classification error...\n\n\(error.localizedDescription)")
            return
        }

        if request.results == nil {
            print("Vision request had no results.")
            return
        }

        guard let observations = request.results as? [VNClassificationObservation] else {
            print("VNRequest produced the wrong result type: \(type(of: request.results)).")
            return
        }

        predictions = observations
            .prefix(3)
            .map { observation in
            Prediction(
                classification: observation.identifier,
                confidencePercentage: observation.confidence
            )
        }
    }
}

extension ImagePredictorClient: DependencyKey {
    static let liveValue = ImagePredictorClient()
}

struct Prediction {
    let classification: String
    let confidencePercentage: Float
}
