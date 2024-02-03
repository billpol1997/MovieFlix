//
//  MovieTableViewCellModel.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 1/2/24.
//

import Foundation

final class MovieTableViewCellModel {
    let id: Int?
    let title: String?
    let banner: String?
    let releaseDate: String?
    let vote: String?
    var isFavorite: Bool?
    
    init(model: MovieListResultsModel) {
        self.id = model.id
        self.title = model.title
        self.banner = "https://image.tmdb.org/t/p/w500" + (model.backdrop_path ?? "")
        self.releaseDate = model.release_date
        self.vote = "\(String(describing: model.vote_average))"
        self.isFavorite = false
    }
    
    func setFavorite(to status: Bool) {
       isFavorite = status
    }
}
