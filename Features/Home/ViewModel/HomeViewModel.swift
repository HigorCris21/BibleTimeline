//
//  HomeViewModel.swift
//  BibleTimelineApp
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {

    enum State: Equatable {
        case loading
        case loaded
        case error(String)
    }

    @Published private(set) var state: State = .loading

    func load() {
        state = .loaded
    }
}
