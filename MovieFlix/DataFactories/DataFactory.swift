//
//  HomeScreenDataFactory.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 1/2/24.
//

import Foundation

final class DataFactory {
    
    func transformMovieData(with initialData: MovieListModel?) -> [MovieTableViewCellModel] {
        guard  let dataList = initialData?.results else { return [] }
        let movieList = dataList.map({ item in
            MovieTableViewCellModel(model: item)
        })
        return movieList
    }
    
    func transformDetailData(with details: MovieDetailModel, reviews: MovieReviewsModel) -> DetailModel {
        let movie = DetailModel(details: details, reviews: reviews)
        return movie
    }
}
