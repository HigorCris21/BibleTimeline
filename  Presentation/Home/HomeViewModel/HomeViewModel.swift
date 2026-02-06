//
//  HomeViewModel.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import Foundation

@MainActor
final class HomeViewModel: ObservableObject {

    enum State: Equatable {
        case loading
        case loaded([ChronologyItem])
        case error(String)
    }

    @Published private(set) var state: State = .loading

    private let loader: ChronologyLoading

    init(loader: ChronologyLoading = ChronologyLoader()) {
        self.loader = loader
    }

    func load() {
        do {
            let items = try loader.loadGospelsChronology()
            state = .loaded(items)
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
