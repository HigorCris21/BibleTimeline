
//  ExploreViewModel.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

import SwiftUI

@MainActor
final class ExploreViewModel: ObservableObject {

    // MARK: - State
    enum State: Equatable {
        case loading
        case loaded([ChronologyItem])
        case error(String)
    }

    // MARK: - Published
    @Published private(set) var state: State = .loading

    // MARK: - Dependencies
    private let loader: ChronologyLoading

    // MARK: - Init
    init(loader: ChronologyLoading = ChronologyLoader()) {
        self.loader = loader
    }

    // MARK: - Actions
    func load() {
        guard case .loading = state else { return }

        do {
            let items = try loader.loadGospelsChronology()
            state = .loaded(items)
        } catch {
            state = .error("Não foi possível carregar a cronologia.")
        }
    }

    func retry() {
        state = .loading
        load()
    }
}
