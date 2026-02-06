//
//  HomeView.swift
//  BibleTimelineApp
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    heroHeader

                    sectionTitle("Hoje")
                    verseOfDayCard

                    sectionTitle("Leitura")
                    startReadingCard
                }
                .padding(.horizontal, 16)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .appScreenBackground()
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}



// MARK: - Sections
private extension HomeView {

    var heroHeader: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Bom dia, Higor")
                    .font(.title.weight(.semibold))
                    .foregroundStyle(Theme.primaryText)

                Text("Leia a Bíblia em ordem cronológica, sem perder o fio da narrativa.")
                    .font(.subheadline)
                    .foregroundStyle(Theme.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Button {
                print("Continue in Mark")
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "play.circle.fill")
                        .font(.title3)
                    Text("Continuar em Marcos")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .opacity(0.9)
                }
                .foregroundStyle(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Theme.accent)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Theme.surface)
        )
    }

    func sectionTitle(_ text: String) -> some View {
        Text(text.uppercased())
            .font(.footnote.weight(.semibold))
            .foregroundStyle(Theme.secondaryText)
            .padding(.top, 2)
    }

    var verseOfDayCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "sun.max.fill")
                    .foregroundStyle(Theme.accent)

                Text("Verso do dia")
                    .font(.headline)
                    .foregroundStyle(Theme.primaryText)

                Spacer()

                referenceChip("Marcos 1:15")
            }

            Text("“O tempo está cumprido, e o reino de Deus está próximo; arrependei-vos e crede no evangelho.”")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Theme.primaryText)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 2)

            Text("Toque para abrir no contexto")
                .font(.footnote)
                .foregroundStyle(Theme.secondaryText)
        }
        .appCard()
    }

    var startReadingCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Início da narrativa")
                        .font(.headline)
                        .foregroundStyle(Theme.primaryText)

                    Text("Comece a leitura cronológica")
                        .font(.subheadline)
                        .foregroundStyle(Theme.secondaryText)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                Image(systemName: "book.fill")
                    .foregroundStyle(Theme.accent)
            }

            Divider()
                .opacity(0.25)

            Button {
                print("Start reading Mark")
            } label: {
                HStack {
                    Text("Começar agora")
                        .font(.headline)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(.footnote.weight(.semibold))
                }
                .foregroundStyle(Theme.primaryText)
                .padding(.vertical, 12)
                .padding(.horizontal, 14)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Theme.accent.opacity(0.12))
                )
            }
            .buttonStyle(.plain)
        }
        .appCard()
    }

    func referenceChip(_ text: String) -> some View {
        Text(text)
            .font(.caption.weight(.semibold))
            .foregroundStyle(Theme.primaryText)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                Capsule(style: .continuous)
                    .fill(Theme.accent.opacity(0.15))
            )
    }
}
