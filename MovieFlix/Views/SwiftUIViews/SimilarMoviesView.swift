//
//  SimilarMoviesView.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 2/2/24.
//

import SwiftUI
import Kingfisher

struct SimilarMoviesView: View {
    var movies: [MovieDetailModel]
    let showMovie: (Int) -> ()
    
    var body: some View {
        container
            .background(Color.clear)
    }
    
    var container: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            movieCollection
        }
    }
    
    var header: some View {
        VStack(alignment: .leading) {
            Text("Similar Movies")
                .foregroundColor(.blue)
                .font(.caption)
                .fontWeight(.bold)
        }
    }
    
    var movieCollection: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 48) {
                ForEach(movies, id: \.id) { movie in
                    movieTile(model: movie)
                }
            }
        }
    }
    
    func movieTile(model: MovieDetailModel) -> some View {
        KFImage(URL(string: "https://image.tmdb.org/t/p/w500" + (model.poster_path ?? "")))
            .resizable()
            .frame(width: 100, height: 150)
            .cornerRadius(4)
            .onTapGesture {
                guard let id = model.id else { return }
                self.showMovie(id)
            }
    }
}

