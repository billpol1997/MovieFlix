//
//  MovieListModel.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 1/2/24.
//

import Foundation

struct MovieListModel: Decodable {
    let page: Int?
    let results: [MovieListResultsModel]?
    let total_pages: Int?
    let total_results: Int?
}

struct MovieListResultsModel: Decodable {
    let backdrop_path: String?
    let id: Int?
    let release_date: String?
    let title: String?
    let vote_average: Double?
    let vote_count: Int?
}
