//
//  SearchView.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//

//
//  SearchView.swift
//  BibleTimeline
//
//  Created by Higor  Lo Castro on 10/02/26.
//



import SwiftUI

// MARK: - SearchView
struct SearchView: View {

    // MARK: Dependencies (SOLID: vem de fora)
    let bibleTextService: BibleTextService

    // MARK: State
    @StateObject private var viewModel = SearchViewModel()
    @State private var readingPosition: ReadingPosition?

    // MARK: Init
    init(bibleTextService: BibleTextService) {
        self.bibleTextService = bibleTextService
    }

    // MARK: Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                bookCard
                chapterCard
                readButton
                Spacer()
            }
            .padding(16)
            .navigationTitle("Buscar")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(item: $readingPosition) { position in
                ReadingView(
                    position: position,
                    bibleTextService: bibleTextService
                )
            }
        }
        .appScreenBackground()
    }
}

// MARK: - UI
private extension SearchView {

    // MARK: Livro
    var bookCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "book.closed.fill")
                .font(.title3)
                .foregroundStyle(Theme.accent)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Livro")
                    .font(.headline)
                    .foregroundStyle(Theme.primaryText)

                Text("Evangelhos")
                    .font(.footnote)
                    .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            Picker(
                "Livro",
                selection: Binding(
                    get: { viewModel.selectedBook },
                    set: { viewModel.onChangeBook($0) }
                )
            ) {
                ForEach(GospelBook.allCases) { book in
                    Text(book.displayName).tag(book)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
        .appCard()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Livro")
        .accessibilityValue(viewModel.selectedBook.displayName)
    }

    // MARK: Capítulo
    var chapterCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "number.circle.fill")
                .font(.title3)
                .foregroundStyle(Theme.accent)
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 2) {
                Text("Capítulo")
                    .font(.headline)
                    .foregroundStyle(Theme.primaryText)

                Text("Selecione o capítulo")
                    .font(.footnote)
                    .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            Picker("Capítulo", selection: $viewModel.selectedChapter) {
                ForEach(viewModel.availableChapters, id: \.self) { chapter in
                    Text("\(chapter)").tag(chapter)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
        .appCard()
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Capítulo")
        .accessibilityValue("\(viewModel.selectedChapter)")
    }

    // MARK: Ação principal
    var readButton: some View {
        Button {
            readingPosition = ReadingPosition(
                book: viewModel.selectedBook.rawValue,
                chapter: viewModel.selectedChapter,
                verse: nil
            )
        } label: {
            HStack {
                Spacer()
                Text("Ler")
                    .font(.headline)
                Spacer()
            }
            .padding(.vertical, 12)
        }
        .buttonStyle(.borderedProminent)
        .tint(Theme.accent)
        .disabled(viewModel.availableChapters.isEmpty)
        .accessibilityHint("Abrir a leitura no livro e capítulo selecionados")
    }
}
