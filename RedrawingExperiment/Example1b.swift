//
//  Created by Showmax
//

import SwiftUI

enum Example1b {

    // MARK: - Model

    class SeriesModel: ObservableObject {

        @Published var title: String = "Tali’s Wedding Diary"
        @Published var isMyFavourite: Bool = false
        @Published var episodes: [Episode] = [
            Episode(title: "1st: The Engagement"),
            Episode(title: "2nd: The Bridesmaids"),
            Episode(title: "3rd: The Venue"),
            Episode(title: "4th: The Dress"),
            Episode(title: "5th: The Invitations"),
            Episode(title: "6th: The Bachelorette")
        ]

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
        @StateObject var model = SeriesModel()
        var body: some View {
            VStack(spacing: 16) {
                TitleView(title: $model.title)
                MyFavouriteView(isMyFavourite: $model.isMyFavourite)
                EpisodesView(
                    episodes: $model.episodes,
                    toggleFavouriteEpisode: { model.toggleFavouriteEpisode($0) }
                )
            }
        }
    }

    struct TitleView: View {
        @Binding var title: String /// ➡️ Changed to Binding.
        var body: some View {
            Text(title)
                .font(.largeTitle)
                .background(.debug)
        }
    }

    struct MyFavouriteView: View {
        @Binding var isMyFavourite: Bool /// ➡️ Changed to Binding.
        var body: some View {
            HStack {
               Button(
                  action: { isMyFavourite.toggle() },
                  label: {
                      Image(systemName: isMyFavourite ? "heart.fill" : "heart")
                      Text(isMyFavourite ? "Remove from favourites" : "Add to favourites")
                  }
               )
            }
            .background(.debug)
        }
    }

    struct EpisodesView: View {
        @Binding var episodes: [SeriesModel.Episode] /// ➡️ Changed to Binding.
        let toggleFavouriteEpisode: (SeriesModel.Episode.ID) -> Void

        var body: some View {
            VStack {
                Text("Episodes")
                    .font(.headline)
                ForEach(episodes) { episode in
                    HStack {
                        Text(episode.title).font(.body)
                        Spacer()
                        Button(
                            action: {
                                toggleFavouriteEpisode(episode.id)
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
            .background(.debug)
        }
    }
}

extension Example1b.SeriesModel {
    struct Episode: Identifiable {
        let id = UUID()
        let title: String
        var isMyFavourite: Bool = false
    }
}
