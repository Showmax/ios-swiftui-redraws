//
//  Created by Showmax
//

import SwiftUI
import Combine

enum Example3d {

    // MARK: - Model

    /// ➡️ Changed to three separate models.
    /// ➡️ Each episode separate model instance.

    /// TODO: this should be actor to be thread safe when storing to `favourites` set.
    class IsMyFavouriteManager {
        struct Change {
            let id: UUID
            let title: String
            let isMyFavourite: Bool
        }
        lazy var didChangeFavourite: AnyPublisher<Change, Never> = didChangeFavouriteSubject.eraseToAnyPublisher()
        private let didChangeFavouriteSubject = PassthroughSubject<Change, Never>()

        var favourites: Set<UUID> = []

        func addToFavourites(_ id: UUID, title: String) {
            guard !favourites.contains(id) else { return }
            favourites.insert(id)
            didChangeFavouriteSubject.send(Change(id: id, title: title, isMyFavourite: true))
        }

        func removeFromFavourites(_ id: UUID, title: String) {
            guard favourites.contains(id) else { return }
            favourites.remove(id)
            didChangeFavouriteSubject.send(Change(id: id, title: title, isMyFavourite: false))
        }
    }

    static let sharedFavouritesManager = IsMyFavouriteManager()

    class SeriesModel: ObservableObject {
        @Published var title: String = "Tali’s Wedding Diary"
        @Published var isMyFavourite: Bool = false
    }

    class EpisodesModel: ObservableObject {
        /// Dependencies:
        let favouritesManager: IsMyFavouriteManager = sharedFavouritesManager

        /// Properties:
        /// ➡️ Now this will change only if we want to replace all episodes with different ones.
        /// ➡️ Like when switching between two seasons.
        /// ➡️ But we won't emit change when there is some little change inside single episode.
        @Published var episodes: [EpisodeModel] = []
        var cancellableBag: Set<AnyCancellable> = []

        init() {
            episodes = [
                EpisodeModel(title: "1st: The Engagement"),
                EpisodeModel(title: "2nd: The Bridesmaids"),
                EpisodeModel(title: "3rd: The Venue"),
                EpisodeModel(title: "4th: The Dress"),
                EpisodeModel(title: "5th: The Invitations"),
                EpisodeModel(title: "6th: The Bachelorette")
            ] + (7...100_000).map {
                EpisodeModel(title: "#\($0): The Bachelorette")
            }

            sharedFavouritesManager.didChangeFavourite
                .sink(receiveValue: { change in
                    print("Did change \(change.title) - isMyFavourite \(change.isMyFavourite)")
                })
                .store(in: &cancellableBag)
        }
    }

    /// ➡️ Handles changes related to this specific episode.
    class EpisodeModel: ObservableObject, Identifiable {
        /// Dependencies:
        let favouritesManager: IsMyFavouriteManager = sharedFavouritesManager

        /// Properties:
        let id = UUID()
        let title: String
        @Published var isMyFavourite: Bool = false {
            didSet {
                if isMyFavourite {
                    favouritesManager.addToFavourites(id, title: title)
                } else {
                    favouritesManager.removeFromFavourites(id, title: title)
                }
            }
        }

        init(title: String) {
            self.title = title
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
