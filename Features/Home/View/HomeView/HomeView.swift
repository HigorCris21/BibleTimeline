//
//  HomeView.swift
//  BibleTimelineApp
//


import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var readingPosition: ReadingPosition?

    // MARK: - Persistence
    @AppStorage(AppStorageKeys.lastReadingPosition)
    private var lastReadingPositionData: Data = Data()

    // MARK: - Derived
    private var lastReadingPosition: ReadingPosition? {
        try? JSONDecoder().decode(ReadingPosition.self, from: lastReadingPositionData)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(item: $readingPosition) { position in
                    ReadingView(position: position)
                }
        }
        .appScreenBackground()
        .task {
            // Evita recarregar se a View for recriada.
            if case .loading = viewModel.state {
                viewModel.load()
            }
        }
    }
}

// MARK: - State Routing (State-driven UI)
private extension HomeView {

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
}

// MARK: - State Views (Renderers)
private extension HomeView {

    // MARK: Loading
    var loadingView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Theme.surface.opacity(0.6))
                    .frame(height: 150)

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Theme.surface.opacity(0.6))
                    .frame(height: 140)

                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Theme.surface.opacity(0.6))
                    .frame(height: 170)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
    }

    // MARK: Error
    func errorView(message: String) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Não foi possível carregar a cronologia")
                    .font(.headline)
                    .foregroundStyle(Theme.primaryText)

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)

                Button("Tentar novamente") {
                    viewModel.load()
                }
                .buttonStyle(.plain)
                .padding(.top, 8)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Theme.surface)
            )
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
    }

    // MARK: Loaded
    func loadedView(items: [ChronologyItem]) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {

                HeroHeader(
                    title: "Bom dia, Higor",
                    subtitle: "Leia a Bíblia em ordem cronológica, sem perder o fio da narrativa.",
                    ctaTitle: "Continuar leitura",
                    onTapCTA: openLastReadingOrFallback
                )

                SectionTitle("Hoje")

                VerseOfDayCard(
                    reference: "Marcos 1:15",
                    verse: "“O tempo está cumprido, e o reino de Deus está próximo; arrependei-vos e crede no evangelho.”",
                    onTap: {
                        // Se quiser abrir no contexto do verso:
                        // readingPosition = ReadingPosition(book: "Marcos", chapter: 1, verse: 15)
                    }
                )

                SectionTitle("Leitura")

                StartReadingCard(
                    onTap: startNewReading
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
    }
}

    // MARK: - Actions
    private extension HomeView {

        var openLastReadingOrFallback: () -> Void {
            {
                let fallback = ReadingPosition(book: "Marcos", chapter: 1, verse: nil)
                readingPosition = lastReadingPosition ?? fallback
            }
        }

        var startNewReading: () -> Void {
            {
                // Sempre começa do zero (você pode escolher outro "início" depois)
                readingPosition = ReadingPosition(book: "Marcos", chapter: 1, verse: nil)

                // (Opcional) Se você quiser que "Começar agora" realmente zere o progresso salvo:
                lastReadingPositionData = Data()
            }
        }
    }


