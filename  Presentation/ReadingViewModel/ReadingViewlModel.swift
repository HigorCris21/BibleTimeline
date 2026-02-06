//
//  ReadingViewlModel.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 06/02/26.
//

import SwiftUI

@MainActor
final class ReadingViewModel: ObservableObject {

    enum State: Equatable {
        case loading
        case loaded(reference: String, text: String)
        case error(message: String)
    }

    @Published private(set) var state: State = .loading
    @Published private(set) var position: ReadingPosition

    private let service: BibleTextService

    init(
        position: ReadingPosition,
        service: BibleTextService = MockBibleTextService()
    ) {
        self.position = position
        self.service = service
        Task { await load() }
    }

    func load() async {
        state = .loading
        do {
            let response = try await service.fetchText(position: position)
            state = .loaded(reference: response.reference, text: response.text)
        } catch {
            state = .error(message: "Não foi possível carregar o texto.")
        }
    }

    func nextChapter() {
        position.chapter += 1
        Task { await load() }
    }

    func previousChapter() {
        position.chapter = max(1, position.chapter - 1)
        Task { await load() }
    }
}

struct ReadingView: View {
    @StateObject private var vm: ReadingViewModel

    init(position: ReadingPosition) {
        _vm = StateObject(wrappedValue: ReadingViewModel(position: position))
    }

    var body: some View {
        content
            .navigationTitle("Leitura")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Anterior") { vm.previousChapter() }
                    Spacer()
                    Button("Próximo") { vm.nextChapter() }
                }
            }
    }

    @ViewBuilder
    private var content: some View {
        switch vm.state {
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .loaded(let reference, let text):
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(reference)
                        .font(.title2)
                        .fontWeight(.semibold)

                    Text(text)
                        .font(.body)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }

        case .error(let message):
            VStack(spacing: 12) {
                Text("Erro")
                    .font(.title3)
                    .fontWeight(.semibold)
                Text(message)
                    .multilineTextAlignment(.center)
                Button("Tentar novamente") {
                    Task { await vm.load() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
        }
    }
}
