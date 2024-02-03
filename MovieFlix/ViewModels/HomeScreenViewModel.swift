//
//  HomeScreenViewModel.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 1/2/24.
//

import Foundation
import Combine


final class HomeScreenViewModel {
    
    private var manager = NetworkManager()
    private var dataFactory = DataFactory()
    private (set) var popularMovies: [MovieTableViewCellModel]?
    private (set) var searchResults: [MovieTableViewCellModel]?
    private (set) var favoriteMovies: [Int] = UserDefaults.standard.array(forKey: "Favorites") as? [Int] ?? []
    let loadedlist = PassthroughSubject<Void, Never>()
    var page: Int = 0
    
    func fetchPopularMovies(with page: Int? = nil) async {
        do {
            let data = try await manager.fetchMovieList()
            if page != nil {
                let extaMovies = dataFactory.transformMovieData(with: data)
                self.popularMovies?.append(contentsOf: extaMovies)
                self.page += 1
            } else {
                self.popularMovies = dataFactory.transformMovieData(with: data)
                self.page = 1
            }
           // loadedlist.send()
        } catch {
            print("Error fetching movie list: \(error)")
        }
    }
    
    func searchMovie(with keyword: String) async {
        do {
            let data = try await manager.searchDataBase(with: keyword)
            self.searchResults = dataFactory.transformMovieData(with: data)
            //loadedlist.send()
        } catch {
            print("Error fetching movie list: \(error)")
        }
    }
    
    func addToFavorites(with id: Int) {
        favoriteMovies.append(id)
        UserDefaults.standard.set(favoriteMovies, forKey: "Favorites")
    }
    
    func removeFromFavorites(with id: Int) {
        favoriteMovies.removeAll(where: {$0 == id})
        UserDefaults.standard.set(favoriteMovies, forKey: "Favorites")
    }

    func loadFavorites(to array: [MovieTableViewCellModel]) -> [MovieTableViewCellModel] {
        if let favorites = UserDefaults.standard.array(forKey: "Favorites") as? [Int] {
            array.map { item in
                if favorites.contains(where: {$0 == item.id}) {
                    item.setFavorite(to: true)
                }
            }
        }
        return array
    }
}