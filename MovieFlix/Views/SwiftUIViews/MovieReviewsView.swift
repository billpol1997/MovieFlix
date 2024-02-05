//
//  MovieReviewsView.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 2/2/24.
//

import SwiftUI

struct MovieReviewsView: View {
    var model: [ReviewModel]
    
    var body: some View {
        container
            .background(Color.clear)
    }
    
    var container: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            reviews
        }
    }
    
    var header: some View {
        VStack {
            Text("Reviews")
                .foregroundColor(.blue)
                .font(.caption)
                .fontWeight(.bold)
        }
    }
    
    var reviews: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(model, id: \.author) { review in
                VStack(alignment: .leading, spacing: 8) {
                    Text(review.author ?? "")
                        .foregroundColor(.yellow)
                        .font(.footnote)
                        .fontWeight(.semibold)
                    Text(review.content ?? "")
                        .foregroundColor(.black.opacity(0.6))
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

