//
//  ExploreView.swift
//  BibleTimelineApp
//

import SwiftUI

// MARK: - ExploreView
struct ExploreView: View {

    // MARK: Dependencies (SOLID: vem de fora)
    let bibleTextService: BibleTextService

    // MARK: State
    @StateObject private var viewModel = ExploreViewModel()
    @State private var readingPosition: ReadingPosition?

    // MARK: Init
    init(bibleTextService: BibleTextService) {
        self.bibleTextService = bibleTextService
    }

    // MARK: Body
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Explorar")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(item: $readingPosition) { position in
                    ReadingView(
                        position: position,
                        bibleTextService: bibleTextService
                    )
                }
        }
        .appScreenBackground()
        .task {
            // Evita reload desnecessário se a View recriar.
            if case .loading = viewModel.state {
                viewModel.load()
            }
        }
    }
}

// MARK: - State-driven UI
private extension ExploreView {

    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView

        case .error(let message):
            errorView(message: message)

        case .loaded(let items):
            loadedView(items: items)
        }
    }

    // MARK: Loading
    var loadingView: some View {
        VStack(spacing: 10) {
            ProgressView()
            Text("Carregando…")
                .font(.footnote)
                .foregroundStyle(Theme.secondaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Carregando conteúdo")
    }

    // MARK: Error
    func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.primaryText)

            Button("Tentar novamente") {
                viewModel.load()
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Erro ao carregar")
        .accessibilityValue(message)
    }

    // MARK: Loaded
    func loadedView(items: [ChronologyItem]) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(items) { item in
                    chronologyCard(item: item)
                }
            }
            .padding(16)
        }
    }

    // MARK: Card
    func chronologyCard(item: ChronologyItem) -> some View {
        Button {
            guard let position = item.startPosition else { return }
            readingPosition = position
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "text.book.closed")
                    .font(.title3)
                    .foregroundStyle(Theme.accent)
                    .accessibilityHidden(true)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(Theme.primaryText)

                    Text(item.displayReference)
                        .font(.footnote)
                        .foregroundStyle(Theme.secondaryText)
                }

                Spacer(minLength: 0)

                Image(systemName: "chevron.right")
                    .foregroundStyle(Theme.secondaryText)
                    .accessibilityHidden(true)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .appCard()
        .accessibilityLabel(item.title)
        .accessibilityValue(item.displayReference)
        .accessibilityHint(item.startPosition == nil ? "Indisponível" : "Abrir leitura")
        .disabled(item.startPosition == nil)
        .opacity(item.startPosition == nil ? 0.55 : 1.0)
    }
}
