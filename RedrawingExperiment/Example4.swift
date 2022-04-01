//
//  Created by Showmax
//

import SwiftUI
import Combine

enum Example4 {

    // MARK: - Model

    class SeriesModel: ObservableObject {

        struct Episode: Identifiable {
            let id = UUID()
            let title: String
            var isMyFavourite: Bool = false
        }

        @Published var title: String = "Tali’s Wedding Diary"
        var isMyFavourite: CurrentValueSubject<Bool, Never> = .init(false)
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
        @State var isMyFavourite: Bool = false
        var body: some View {
            HStack {
               Button(
                    action: { model.isMyFavourite.send(!isMyFavourite) },
                    label: {
                        Image(systemName: isMyFavourite ? "heart.fill" : "heart")
                        Text(isMyFavourite ? "Remove from favourites" : "Add to favourites")
                    }
               )
            }
            .background(.debug)
            .onReceive(model.isMyFavourite) { isMyFavourite = $0 }
        }
    }

    struct EpisodesView: View {
        @ObservedObject var model: SeriesModel

        var body: some View {
            VStack {
                Text("Episodes")
                    .font(.headline)
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
            .background(.debug)
        }
    }

    private struct Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
