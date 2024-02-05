//
//  DetailModel.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 2/2/24.
//

import Foundation


struct DetailModel {
    let id: Int?
    let title: String?
    let banner: String?
    let poster: String?
    let genres: String?
    let description: String?
    let releaseDate: String?
    let runtime: Int?
    let voteAvg: String?
    var isFavorite: Bool?
    let reviews: [ReviewModel]?
    let homePage: String?
    
    init(details: MovieDetailModel, reviews: MovieReviewsModel) {
        self.id = details.id
        self.title = details.title
        self.banner = imagePath + (details.backdrop_path ?? "")
        self.poster = imagePath + (details.poster_path ?? "")
        self.genres = details.genres?.map { $0.name ?? ""}.joined(separator: ", ") ?? ""
        self.description = details.overview
        self.releaseDate = details.release_date
        self.runtime = details.runtime
        self.voteAvg = String(format:" %2.f", (details.vote_average ?? 0) / 2)
        self.reviews = reviews.results
        self.homePage = details.homepage
        if let fav = UserDefaults.standard.array(forKey: "Favorites") as? [Int] {
            if fav.contains(where: {$0 == id}) {
                self.isFavorite = true
            } else {
                self.isFavorite = false
            }
        } else {
            self.isFavorite = false
        }
    }
    
    func minutesToTime(minutes: Int) -> (hours: Int, remainingMinutes: Int) {
        let hours = minutes / 60
        let remainingMinutes = minutes % 60
        
        return (hours, remainingMinutes)
    }
    
    func intToStringTime(hours: Int, minutes: Int) -> String {
        if minutes <= 0 {
            return "\(hours)h"
        } else {
            return "\(hours)h \(minutes)m"
        }
    }
    
    func setupRuntime() -> String {
        let time: (Int, Int) = minutesToTime(minutes: runtime ?? 0)
        return intToStringTime(hours: time.0, minutes: time.1)
    }
    
    func formatDate(inputDateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let inputDate = dateFormatter.date(from: inputDateString) {
            dateFormatter.dateFormat = "d MMMM yyyy"
            let formattedDate = dateFormatter.string(from: inputDate)
            return formattedDate
        } else {
            return nil
        }
    }
}
