//
//  MovieAttributesView.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 2/2/24.
//

import SwiftUI

struct MovieAttributesView: View {
    var detail: DetailModel
    
    var body: some View {
        container
            .background(Color.clear)
    }
    
    var container: some View {
        VStack(alignment: .leading, spacing: 32) {
            runtime
            description
        }
    }
    
    var runtime: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("Runtime")
                    .foregroundColor(.blue)
                    .font(.caption)
                    .fontWeight(.bold)
                Text(detail.setupRuntime())
                    .foregroundColor(.orange)
                    .font(.footnote)
                    .fontWeight(.bold)
            }
            Spacer()
        }
        
    }
    
    var description: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Description")
                .foregroundColor(.blue)
                .font(.caption)
                .fontWeight(.bold)
            Text(detail.description ?? "")
                .foregroundColor(.black.opacity(0.6))
                .font(.footnote)
                .fontWeight(.bold)
        }
    }
}

