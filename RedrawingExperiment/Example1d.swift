//
//  Created by Showmax
//

import SwiftUI

enum Example1d {

    // MARK: - Model

    class SeriesModel: ObservableObject {

        @Published var title: String = "Tali’s Wedding Diary"
        @Published var isMyFavourite: Bool = false

        /// ➡️ Try lot of episodes
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

extension Example1d.SeriesModel {
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
