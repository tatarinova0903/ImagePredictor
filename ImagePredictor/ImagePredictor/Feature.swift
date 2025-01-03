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
        case predictionIsReady(String)
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
                return .run { send in
                    let prediction = predictor.predict()
                    await send(.predictionIsReady(prediction))
                }
            case let .predictionIsReady(prediction):
                state.prediction = prediction
                return .none
            }
        }
    }

    private func loadTransferable(from imageSelection: PhotosPickerItem) async -> ImageState {
        do {
            if let loadRes = try await imageSelection.loadTransferable(type: ImageToPredict.self) {
                return .success(loadRes.image)
            } else {
                return .empty
            }
        } catch {
            return .failure(error)
        }
    }
}


private struct ImageToPredict: Transferable {
    let image: Image

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(importedContentType: .image) { data in
            guard let uiImage = UIImage(data: data) else {
                throw TransferError.importFailed
            }
            let image = Image(uiImage: uiImage)
            return ImageToPredict(image: image)
        }
    }
}
