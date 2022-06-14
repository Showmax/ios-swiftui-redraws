//
//  Created by Showmax
//

import SwiftUI
import Combine

/// ➡️ Do manually yourself all the work that is doing SwiftUI.
enum Example4 {

    // MARK: - Model

    class SeriesModel: ObservableObject {

        @Published var title: String = "Tali’s Wedding Diary"

        /// ➡️ Removed @Published wrapper.
        /// ➡️ Changed it to Combine subject, that is also publisher so in SwiftUI we can listen on its changes.
        /// ➡️ This means setting won't call internal `objectWillChange` publisher. We have separate publisher here.
        var isMyFavourite: CurrentValueSubject<Bool, Never> = .init(false)

        @Published var episodes: [Episode] = [
            Episode(title: "1st: The Engagement"),
            Episode(title: "2nd: The Bridesmaids"),
            Episode(title: "3rd: The Venue"),
            Episode(title: "4th: The Dress"),
            Episode(title: "5th: The Invitations"),
            Episode(title: "6th: The Bachelorette")
        ] + (1...100_000).map { Episode(title: "#\($0): The Bachelorette") }
    }

    // MARK: - Views

    struct ContentView: View {
        @StateObject private var model = SeriesModel()
        var body: some View {
            VStack(spacing: 16) {
                TitleView(title: model.title)
                MyFavouriteView(model: model)
                EpisodesView(model: model)
            }
        }
    }

    struct TitleView: View {
        let title: String
        var body: some View {
            Text(title)
                .font(.largeTitle)
                .background(.debug)
        }
    }

    struct MyFavouriteView: View {
        @ObservedObject var model: SeriesModel

        /// ➡️ Here will be stored latest state to be shown in UI.
        /// SwiftUI will redraw anytime this value changes.
        @State private var isMyFavourite: Bool = false

        var body: some View {
            HStack {
               Button(
                    action: { model.isMyFavourite.send(!isMyFavourite) },
                    label: {
                        /// ➡️ Set @State value into some view
                        /// We could also pass it deeper via @Binding and then surrounding views won't be redrawn.
                        Image(systemName: isMyFavourite ? "heart.fill" : "heart")
                        Text(isMyFavourite ? "Remove from favourites" : "Add to favourites")
                    }
               )
            }
            .background(.debug)
            .onReceive(model.isMyFavourite) { /// ➡️ Start listening on changes in model `isMyFavourite` publisher.
                /// ➡️ On change store value in @State, so that SwiftUI can rerender view.
                isMyFavourite = $0
            }
        }
    }

    struct EpisodesView: View {
        @ObservedObject var model: SeriesModel
        var body: some View {
            VStack {
                Text("Episodes")
                    .font(.headline)
                List {
                    ForEach(model.episodes) { episode in
                        HStack {
                            Text(episode.title).font(.body)
                            Spacer()
                            Button(
                                action: {
                                    model.toggleFavouriteEpisode(episode.id)
                                },
                                label: {
                                    Image(systemName: episode.isMyFavourite ? "heart.fill" : "heart")
                                }
                            ).buttonStyle(.borderless)
                        }
                        .padding()
                        .background(.debug)
                    }
                }
                .listStyle(.plain)
            }
            .background(.debug)
        }
    }
}

extension Example4.SeriesModel {
    struct Episode: Identifiable {
        let id = UUID()
        let title: String
        var isMyFavourite: Bool = false
    }

    func toggleFavouriteEpisode(_ episodeID: Episode.ID) {
        episodes = episodes.map { episode in
            guard episode.id == episodeID else { return episode }
            var episode = episode
            episode.isMyFavourite.toggle()
            return episode
        }
    }
}
