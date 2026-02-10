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

    // MARK: State
    @StateObject private var viewModel = SearchViewModel()
    @State private var readingPosition: ReadingPosition?

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
            .navigationDestination(item: $readingPosition) { position in
                ReadingView(position: position)
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

            VStack(alignment: .leading, spacing: 2) {
                Text("Livro")
                    .font(.headline)
                    .foregroundStyle(Theme.primaryText)

                Text("Evangelhos")
                    .font(.footnote)
                    .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            // Picker com label semântico (acessibilidade)
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
    }

    // MARK: Capítulo
    var chapterCard: some View {
        HStack(spacing: 12) {
            Image(systemName: "number.circle.fill")
                .font(.title3)
                .foregroundStyle(Theme.accent)

            VStack(alignment: .leading, spacing: 2) {
                Text("Capítulo")
                    .font(.headline)
                    .foregroundStyle(Theme.primaryText)

                Text("Selecione o capítulo")
                    .font(.footnote)
                    .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            // Picker com label semântico (acessibilidade)
            Picker("Capítulo", selection: $viewModel.selectedChapter) {
                ForEach(viewModel.availableChapters, id: \.self) { chapter in
                    Text("\(chapter)").tag(chapter)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
        }
        .appCard()
    }

    // MARK: Ação principal
    var readButton: some View {
        Button {
            // Abre a leitura no ponto escolhido (IDs USFM: MAT/MRK/LUK/JHN)
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
        // Defesa extra: se por algum motivo não houver capítulos, não permite avançar
        .disabled(viewModel.availableChapters.isEmpty)
    }
}
