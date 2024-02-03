//
//  NetworkManager.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 1/2/24.
//

import Foundation
import Alamofire

final class NetworkManager {
    let networkService = GenericAPICall()
    let accessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIwZjIyYzdiMDBjNTdlYTk2N2ZhMTg5ZGFmZDk2MzA3NiIsInN1YiI6IjY0NTM5NDY4ZDQ4Y2VlMDBmY2VkZTY5YSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.S-sRwU7SB8gnT_3RYSC-6Hm48jEP3Hd6eHiHKTz13nA"
    
    
    func fetchMovieList(page: Int? = nil) async throws -> MovieListModel {
        let requestUrl = "https://api.themoviedb.org/3/movie/popular"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "accept" : "application/json"
        ]
        let parameters: Parameters = [
            "page": page ?? 1
        ]
        let movieData: MovieListModel = try await networkService.fetchData(from: requestUrl, method: .get, headers: headers, parameters: parameters ,responseModel: MovieListModel.self)
        return movieData
    }
    
    func searchDataBase(with keyword: String) async throws -> MovieListModel {
        let requestUrl = "https://api.themoviedb.org/3/search/movie"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "accept" : "application/json"
        ]
        let parameters: Parameters = [
            "query": keyword
        ]
        let movieData: MovieListModel = try await networkService.fetchData(from: requestUrl, method: .get, headers: headers, parameters: parameters , responseModel: MovieListModel.self)
        return movieData
    }
    
    func fetchMovieDetails(with id: Int) async throws -> MovieDetailModel {
        let requestUrl = "https://api.themoviedb.org/3/movie/\(id)"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "accept" : "application/json"
        ]
        let movieData: MovieDetailModel = try await networkService.fetchData(from: requestUrl, method: .get, headers: headers, responseModel: MovieDetailModel.self)
        return movieData
    }
    
    func fetchMovieReviews(with id: Int) async throws -> MovieReviewsModel {
        let requestUrl = "https://api.themoviedb.org/3/movie/\(id)/reviews"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "accept" : "application/json"
        ]
        let movieData: MovieReviewsModel = try await networkService.fetchData(from: requestUrl, method: .get, headers: headers, responseModel: MovieReviewsModel.self)
        return movieData
    }
    
    func fetchSimilarMovies(with id: Int) async throws -> SimilarMoviesModel {
        let requestUrl = "https://api.themoviedb.org/3/movie/\(id)/similar"
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)",
            "accept" : "application/json"
        ]
        let movieData: SimilarMoviesModel = try await networkService.fetchData(from: requestUrl, method: .get, headers: headers, responseModel: SimilarMoviesModel.self)
        return movieData
    }
}
