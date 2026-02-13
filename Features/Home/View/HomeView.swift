//
//  HomeView.swift
//  BibleTimelineApp
//

import SwiftUI

struct HomeView: View {

    // MARK: Dependencies (SOLID: vem de fora)
    let bibleTextService: BibleTextService

    // MARK: - State
    @StateObject private var viewModel = HomeViewModel()
    @State private var readingPosition: ReadingPosition?

    // MARK: - Debug routing
    @State private var isShowingAPIDebug: Bool = false

    // MARK: - Persistence
    @AppStorage(AppStorageKeys.lastReadingPosition)
    private var lastReadingPositionData: Data = Data()

    // MARK: - Derived
    private var lastReadingPosition: ReadingPosition? {
        try? JSONDecoder().decode(ReadingPosition.self, from: lastReadingPositionData)
    }

    // MARK: - Init
    init(bibleTextService: BibleTextService) {
        self.bibleTextService = bibleTextService
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            content
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(item: $readingPosition) { position in
                    ReadingView(
                        position: position,
                        bibleTextService: bibleTextService
                    )
                }
               //  ----------- Debug screen (presentação simples)     ---------
                .sheet(isPresented: $isShowingAPIDebug) {
                    NavigationStack {
                        APIBibleDebugView()
                    }
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

// MARK: - State Routing (State-driven UI)
private extension HomeView {

    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .loading:
            loadingView

        case .error(let message):
            errorView(message: message)

        case .loaded:
            loadedView
        }
    }
}

// MARK: - State Views
private extension HomeView {

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

    func errorView(message: String) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {

                Text("Não foi possível carregar a tela inicial")
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

    var loadedView: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {

                // Hero
                HeroHeader(
                    title: "Bom dia, Higor",
                    subtitle: "Leia a Bíblia em ordem cronológica, sem perder o fio da narrativa.",
                    ctaTitle: "Continuar leitura",
                    onTapCTA: openLastReadingOrFallback
                )

                // ✅ Debug (temporário)
                Button {
                    isShowingAPIDebug = true
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "stethoscope")
                        Text("Debug API")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.footnote)
                            .opacity(0.7)
                    }
                    .foregroundStyle(Theme.primaryText)
                    .padding(14)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Theme.surface)
                    )
                }
                .buttonStyle(.plain)

                // Hoje
                SectionTitle("Hoje")

                VerseOfDayCard(
                    reference: "Marcos 1:15",
                    verse: "“O tempo está cumprido, e o reino de Deus está próximo; arrependei-vos e crede no evangelho.”",
                    onTap: { }
                )

                // Leitura
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
            readingPosition = lastReadingPosition ?? .mark1
        }
    }

    var startNewReading: () -> Void {
        {
            // Começar agora = SEMPRE inicia do início (Marcos 1)
            readingPosition = .mark1
        }
    }
}

