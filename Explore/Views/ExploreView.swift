import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                exploreCard(title: "Planos de leitura", subtitle: "Em breve", icon: "checklist")
                exploreCard(title: "Favoritos", subtitle: "Versos salvos", icon: "bookmark.fill")
                exploreCard(title: "Histórico", subtitle: "Onde você parou", icon: "clock.fill")
                Spacer()
            }
            .padding(16)
            .navigationTitle("Explorar")
        }
        .appScreenBackground()
    }

    private func exploreCard(title: String, subtitle: String, icon: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(Theme.accent)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Theme.primaryText)

                Text(subtitle)
                    .font(.footnote)
                    .foregroundStyle(Theme.secondaryText)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(Theme.secondaryText)
        }
        .appCard()
    }
}
