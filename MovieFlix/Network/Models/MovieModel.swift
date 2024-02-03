//
//  MovieModel.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 2/2/24.
//

import Foundation

//MARK: Detail
struct MovieDetailModel: Decodable {
    let id: Int?
    let backdrop_path: String?
    let poster_path: String?
    let genres: [GenreModel]?
    let title: String?
    let overview: String?
    let release_date: String?
    let runtime: Int?
    let vote_average: Double?
    let homepage: String?
}

struct GenreModel: Decodable {
    let name: String?
    let id: Int?
}

//MARK: Review
struct MovieReviewsModel: Decodable {
    let id: Int?
    let results: [ReviewModel]?
}

struct ReviewModel: Decodable {
    let author: String?
    let content: String?
}

//MARK: Similar
struct SimilarMoviesModel: Decodable {
    let results: [MovieDetailModel]?
}
