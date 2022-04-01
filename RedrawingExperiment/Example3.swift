//
//  Created by Showmax
//

import SwiftUI

enum Example3 {

    // MARK: - Model

    class SeriesModel: ObservableObject {
        @Published var title: String = "Tali’s Wedding Diary"
        @Published var isMyFavourite: Bool = false
    }

    class EpisodesModel: ObservableObject {
        @Published var episodes: [EpisodeModel] = [
            EpisodeModel(title: "1st: The Engagement"),
            EpisodeModel(title: "2nd: The Bridesmaids"),
            EpisodeModel(title: "3rd: The Venue"),
            EpisodeModel(title: "4th: The Dress"),
            EpisodeModel(title: "5th: The Invitations"),
            EpisodeModel(title: "6th: The Bachelorette")
        ]
    }

    class EpisodeModel: ObservableObject, Identifiable {
        let id = UUID()
        let title: String
        @Published var isMyFavourite: Bool = false

        init(title: String) {
            self.title = title
        }
    }

    // MARK: - Views

    struct ContentView: View {
        @StateObject var seriesModel = SeriesModel()
        @StateObject var episodesModel = EpisodesModel()
        var body: some View {
            VStack(spacing: 16) {
                TitleView(title: seriesModel.title)
                MyFavouriteView(model: seriesModel)
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
                ForEach(model.episodes) { episode in
                    EpisodeView(model: episode)
                }
            }
            .background(.debug)
        }
    }

    struct EpisodeView: View {
        @ObservedObject var model: EpisodeModel

        var body: some View {
            HStack {
                Text(model.title).font(.body)
                Spacer()
                Button(
                    action: {
                        model.isMyFavourite.toggle()
                    },
                    label: {
                        Image(systemName: model.isMyFavourite ? "heart.fill" : "heart")
                    }
                ).buttonStyle(.borderless)
            }
            .padding()
            .background(.debug)
        }
    }

    private struct Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}