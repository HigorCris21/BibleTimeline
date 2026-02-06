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

                    HeroHeader(
                        title: "Bom dia, Higor",
                        subtitle: "Leia a Bíblia em ordem cronológica, sem perder o fio da narrativa.",
                        ctaTitle: "Continuar em Marcos",
                        onTapCTA: { print("Continue in Mark") }
                    )

                    SectionTitle("Hoje")

                    VerseOfDayCard(
                        reference: "Marcos 1:15",
                        verse: "“O tempo está cumprido, e o reino de Deus está próximo; arrependei-vos e crede no evangelho.”",
                        onTap: { print("Open verse context") }
                    )

                    SectionTitle("Leitura")

                    StartReadingCard(
                        onTap: { print("Start reading Mark") }
                    )
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


