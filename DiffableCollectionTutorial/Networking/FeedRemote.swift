//
//  FeedRemote.swift
//  DiffableCollectionTutorial
//
//  Created by James Rochabrun on 6/7/21.
//

import Combine
import UIKit


@MainActor
final class FeedRemote: ObservableObject {

    private let client = Client()
    @Published private(set) var musicItems: [MusicItemViewModel] = []

    var request: URLRequest = {
        let urlString = "https://rss.applemarketingtools.com/api/v2/gb/music/most-played/50/albums.json"
        let url = URL(string: urlString)!
        return URLRequest(url: url)
    }()

    @available(iOS 15, *)
    func fetchMusicItems() {
        Task {
            do {
                let container = try await client.fetch(type: Container<MusicItem>.self, with: request)
                DispatchQueue.main.async {
                    self.musicItems = container.feed.results.map { MusicItemViewModel(musicItem: $0) }
                }
            } catch {
                print("The error is --- \((error as! APIError).customDescription)")
            }
        }
    }
}

