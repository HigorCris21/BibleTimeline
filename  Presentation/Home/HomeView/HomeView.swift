//
//  HomeView.swift
//  BibleTimelineApp
//
//
//  HomeView.swift
//  BibleTimelineApp
//

import SwiftUI

struct HomeView: View {
    // MARK: - State
    @StateObject private var viewModel = HomeViewModel()

    // Route tipada (substitui o Bool)
    @State private var readingPosition: ReadingPosition?

    // MARK: - View
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
            // Garante que não recarrega se a View for recriada em algum cenário.
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
        let first = items.first // (se não for usar, pode remover)

        return ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {

                HeroHeader(
                    title: "Bom dia, Higor",
                    subtitle: "Você ainda não iniciou a leitura cronológica.",
                    ctaTitle: "Continuar",
                    onTapCTA: {
                        // Passo 3: abre leitura (mock). Depois você troca por “onde parei”.
                        readingPosition = .mark1
                    }
                )

                SectionTitle("Hoje")

                VerseOfDayCard(
                    reference: "Marcos 1:15",
                    verse: "“O tempo está cumprido, e o reino de Deus está próximo; arrependei-vos e crede no evangelho.”",
                    onTap: {
                        // Se quiser abrir no contexto do verso:
                        // readingPosition = ReadingPosition(book: "Marcos", chapter: 1, verse: 15)
                        print("Open verse context")
                    }
                )

                SectionTitle("Leitura")

                StartReadingCard(
                    onTap: {
                        readingPosition = .mark1
                    }
                )
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 32)
        }
    }
}
