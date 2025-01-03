//
//  Feature.swift
//  ImagePredictor
//
//  Created by Daria Tatarinova on 03.01.2025.
//

import ComposableArchitecture

@Reducer
struct Feature {
    @ObservableState
    struct State: Equatable {
        var image = 0
    }

    enum Action {
        case imageSelected
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .imageSelected:
                state.image += 1
                return .none
            }
        }
    }
}
