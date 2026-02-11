


import SwiftUI

// MARK: - ExploreView
struct ExploreView: View {

    // MARK: State
    @StateObject private var viewModel = ExploreViewModel()
    @State private var readingPosition: ReadingPosition?

    // MARK: Body
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Explorar")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(item: $readingPosition) { position in
                    ReadingView(position: position)
                }
        }
        .appScreenBackground()
        .task {
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
            errorView(message)

        case .loaded(let items):
            loadedView(items)
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
    }

    // MARK: Error
    func errorView(_ message: String) -> some View {
        VStack(spacing: 12) {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.primaryText)

            Button("Tentar novamente") {
                viewModel.retry()
            }
            .buttonStyle(.borderedProminent)
            .tint(Theme.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(16)
    }

    // MARK: Loaded
    func loadedView(_ items: [ChronologyItem]) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12) {
                ForEach(items) { item in
                    chronologyCard(item)
                }
            }
            .padding(16)
        }
    }

    // MARK: Card
    func chronologyCard(_ item: ChronologyItem) -> some View {
        Button {
            guard let position = item.startPosition else { return }
            readingPosition = position
        } label: {
            HStack(spacing: 12) {

                Image(systemName: "text.book.closed")
                    .font(.title3)
                    .foregroundStyle(Theme.accent)

                VStack(alignment: .leading, spacing: 2) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(Theme.primaryText)

                    Text(item.displayReference)
                        .font(.footnote)
                        .foregroundStyle(Theme.secondaryText)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(Theme.secondaryText)
            }
        }
        .buttonStyle(.plain)
        .appCard()
    }
}
