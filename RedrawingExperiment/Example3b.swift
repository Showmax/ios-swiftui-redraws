//
//  Created by Showmax
//

import SwiftUI

enum Example3b {

    // MARK: - Model

    /// ➡️ Changed to three separate models.
    /// ➡️ Each episode separate model instance.

    class SeriesModel: ObservableObject {
        @Published var title: String = "Tali’s Wedding Diary"
        @Published var isMyFavourite: Bool = false
    }

    class EpisodesModel: ObservableObject {
        /// ➡️ Now this will change only if we want to replace all episodes with different ones.
        /// ➡️ Like when switching between two seasons.
        /// ➡️ But we won't emit change when there is some little change inside single episode.
        @Published var episodes: [EpisodeModel] = []

        init() {
            episodes = [
                EpisodeModel(title: "1st: The Engagement", reportDidChange: { [weak self] in self?.episodeModelDidChange($0) }),
                EpisodeModel(title: "2nd: The Bridesmaids", reportDidChange: { [weak self] in self?.episodeModelDidChange($0) }),
                EpisodeModel(title: "3rd: The Venue", reportDidChange: { [weak self] in self?.episodeModelDidChange($0) }),
                EpisodeModel(title: "4th: The Dress", reportDidChange: { [weak self] in self?.episodeModelDidChange($0) }),
                EpisodeModel(title: "5th: The Invitations", reportDidChange: { [weak self] in self?.episodeModelDidChange($0) }),
                EpisodeModel(title: "6th: The Bachelorette", reportDidChange: { [weak self] in self?.episodeModelDidChange($0) })
            ] + (7...100_000).map {
                EpisodeModel(
                    title: "#\($0): The Bachelorette",
                    reportDidChange: { [weak self] in self?.episodeModelDidChange($0) }
                )
            }
        }

        func episodeModelDidChange(_ episodeModel: EpisodeModel) {
            print("Did change \(episodeModel.title) - isMyFavourite \(episodeModel.isMyFavourite)")
        }
    }

    /// ➡️ Handles changes related to this specific episode.
    class EpisodeModel: ObservableObject, Identifiable {
        let id = UUID()
        let title: String
        let reportDidChange: (EpisodeModel) -> Void
        @Published var isMyFavourite: Bool = false {
            didSet {
                reportDidChange(self)
            }
        }

        init(title: String, reportDidChange: @escaping (EpisodeModel) -> Void) {
            self.title = title
            self.reportDidChange = reportDidChange
        }
    }

    // MARK: - Views

    struct ContentView: View {
        @StateObject private var seriesModel = SeriesModel()
        @StateObject private var episodesModel = EpisodesModel()
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
                List {
                    ForEach(model.episodes) { episode in
                        EpisodeView(model: episode)
                    }
                }
                .listStyle(.plain)
            }
            .background(.debug)
        }
    }

    /// ➡️ Each row view listens on separatate ObservableObject model.
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
}
