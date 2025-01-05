//
//  Feature.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 03.01.2025.
//

import SwiftUI
import PhotosUI
import ComposableArchitecture

@Reducer
struct Feature {
    @ObservableState
    struct State {
        var imageState = ImageState.empty
        var prediction: String?
    }

    enum Action {
        case imageSelected(PhotosPickerItem?)
        case imageLoaded(ImageState)
        case predictionIsReady([Prediction])
    }

    @ObservationIgnored
    @Dependency(ImagePredictorClient.self) var predictor

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .imageSelected(pickerItem):
                guard let pickerItem else { return .none }
                state.prediction = nil
                state.imageState = .loading
                return .run { send in
                    let imageState = await loadTransferable(from: pickerItem)
                    await send(.imageLoaded(imageState))
                }
            case let .imageLoaded(imageState):
                state.imageState = imageState
                guard case let .success(image) = imageState else { return .none }
                return .run { send in
                    let predictions = try? await predictor.makePredictions(for: image)
                    await send(.predictionIsReady(predictions ?? []))
                }
            case let .predictionIsReady(predictions):
                state.prediction = makePredictionsDescription(predictions)
                return .none
            }
        }
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) async -> ImageState {
        do {
            if let loadRes = try await imageSelection.loadTransferable(type: ImageToPredict.self) {
                return .success(loadRes.uiImage)
            } else {
                return .empty
            }
        } catch {
            return .failure(error)
        }
    }

    private func makePredictionsDescription(_ predictions: [Prediction]) -> String {
        predictions.reduce("") { partialResult, prediction in
            partialResult + "\(prediction.confidencePercentage.toPercent()) \(prediction.classification)\n"
        }
    }
}


private struct ImageToPredict: Transferable {
    let uiImage: UIImage

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw TransferError.importFailed
            }
            return ImageToPredict(uiImage: uiImage)
        }
    }
}
