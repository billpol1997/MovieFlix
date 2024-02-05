//
//  MovieDetailViewModel.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 2/2/24.
//

import Foundation
import UIKit

final class MovieDetailViewModel: ObservableObject {
    
    private var manager = NetworkManager()
    private var dataFactory = DataFactory()
    private (set) var detail: MovieDetailModel?
    private (set) var reviews: MovieReviewsModel?
    private (set) var similarList: [MovieDetailModel]?
    private (set) var favoriteMovies: [Int] = UserDefaults.standard.array(forKey: "Favorites") as? [Int] ?? []
    @Published var movie: DetailModel?
    let id: Int
    
    init(with id: Int) {
        self.id = id
        setupMovieData(with: self.id)
    }
    
    func setupMovieData(with id: Int) {
        Task {
            do {
                await fetchMovieData(with: id)
            }
        }
    }
    
    @MainActor
    func fetchMovieData(with id: Int) async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                await self.fetchDetailData(with: id)
            }
            
            group.addTask {
                await self.fetchReviewData(with: id)
            }
            
            group.addTask {
                await self.fetchSimilarData(with: id)
            }
            
            await group.waitForAll()
            
            if let detail = detail, let reviews = reviews {
                self.movie = dataFactory.transformDetailData(with: detail, reviews: reviews)
            }
        }
    }
    
    private func fetchDetailData(with id: Int) async {
        do {
            let data = try await manager.fetchMovieDetails(with: id)
            self.detail = data
        } catch {
            print("Error fetching Detail list: \(error)")
        }
    }
    
    private func fetchReviewData(with id: Int) async {
        do {
            let data = try await manager.fetchMovieReviews(with: id)
            self.reviews = data
        } catch {
            print("Error fetching reviews list: \(error)")
        }
    }
    
    private func fetchSimilarData(with id: Int) async {
        do {
            let data = try await manager.fetchSimilarMovies(with: id)
            self.similarList = data.results
            
        } catch {
            print("Error fetching similarList list: \(error)")
        }
    }
    
    func addToFavorites(with id: Int) {
        favoriteMovies.append(id)
        UserDefaults.standard.set(favoriteMovies, forKey: "Favorites")
        movie?.isFavorite = true
    }
    
    func removeFromFavorites(with id: Int) {
        favoriteMovies.removeAll(where: {$0 == id})
        UserDefaults.standard.set(favoriteMovies, forKey: "Favorites")
        movie?.isFavorite = false
    }
    
    func loadFavorite(with id: Int) {
        if let favorites = UserDefaults.standard.array(forKey: "Favorites") as? [Int] {
            if favorites.contains(id) {
                movie?.isFavorite = true
            }
        }
        movie?.isFavorite = false
    }
    
    func shareHomePage() {
        guard let url = movie?.homePage else { return }
        let activityController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController!.present(activityController, animated: true, completion: nil)
    }
}
