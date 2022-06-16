//
//  Created by Showmax
//

import SwiftUI

enum Example2 {

    // MARK: - Model

    /// Changed to two separate models.

    class SeriesModel: ObservableObject {
        @Published var title: String = "Tali’s Wedding Diary"
        @Published var isMyFavourite: Bool = false
    }

    /// ➡️ Here we extracted episodes into separate object.
    class EpisodesModel: ObservableObject {
        @Published var episodes: [Episode] = [
            Episode(title: "1st: The Engagement"),
            Episode(title: "2nd: The Bridesmaids"),
            Episode(title: "3rd: The Venue"),
            Episode(title: "4th: The Dress"),
            Episode(title: "5th: The Invitations"),
            Episode(title: "6th: The Bachelorette")
        ] + (1...50_000).map { Episode(title: "#\($0): The Bachelorette") }
        func toggleFavouriteEpisode(_ episodeID: Episode.ID) {
            episodes = episodes.map { episode in
                guard episode.id == episodeID else { return episode }
                var episode = episode
                episode.isMyFavourite.toggle()
                return episode
            }
        }
    }

    // MARK: - Views

    struct ContentView: View {

        @StateObject private var seriesModel = SeriesModel()

        /// ➡️ Here SwiftUI will start listening to changes in episodes.
        @StateObject private var episodesModel = EpisodesModel()

        var body: some View {
            VStack(spacing: 16) {
                TitleView(title: seriesModel.title)
                MyFavouriteView(model: seriesModel)
                /// ➡️ Changes in episodes, will redraw this view only.
                EpisodesView(model: episodesModel)
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
        var body: some View {
            HStack {
               Button(
                  action: { model.isMyFavourite.toggle() },
                  label: {
                      Image(systemName: model.isMyFavourite ? "heart.fill" : "heart")
                      Text(model.isMyFavourite ? "Remove from favourites" : "Add to favourites")
                  }
               )
            }
            .background(.debug)
        }
    }

    struct EpisodesView: View {
        @ObservedObject var model: EpisodesModel
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
                }.listStyle(.plain)
            }
            .background(.debug)
        }
    }
}

extension Example2.EpisodesModel {
    struct Episode: Identifiable {
        let id = UUID()
        let title: String
        var isMyFavourite: Bool = false
    }
}
