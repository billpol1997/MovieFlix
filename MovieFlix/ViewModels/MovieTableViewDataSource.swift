//
//  MovieTableViewDataSource.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 1/2/24.
//

import Foundation
import UIKit
import Combine
import SkeletonView

protocol MovieTableViewDelegate: AnyObject {
    func movieTableViewDataSource(_: MovieTableViewDataSource, didSelect movie: String?)
}


final class MovieTableViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate, SkeletonTableViewDataSource  {
    
    private var cancellables: Set<AnyCancellable> = []
    weak var delegate: MovieTableViewDelegate?
    var data: [MovieTableViewCellModel]
    let addToFavoritesSubject = PassthroughSubject<Int, Never>()
    let removeToFavoritesSubject = PassthroughSubject<Int, Never>()
    let openMovieSubject = PassthroughSubject<Int, Never>()
    
    init(delegate: MovieTableViewDelegate? = nil, data: [MovieTableViewCellModel]) {
        self.delegate = delegate
        self.data = data
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MovieTableViewCell.dequeueInTableView(tableView, forIndexPath: indexPath)
        cell.setupCell(with: data[indexPath.row])
        cell.addMovieToFavoritesSubject
            .sink { [weak self] id in
                guard let self else { return }
                self.addToFavoritesSubject.send(id)
            }
            .store(in: &cancellables)
        
        cell.removeMovieToFavoritesSubject
            .sink { [weak self] id in
                guard let self else { return }
                self.removeToFavoritesSubject.send(id)
            }
            .store(in: &cancellables)
        
        cell.didTapMovieSubject
            .sink { [weak self] id in
                guard let self else { return }
                openMovieSubject.send(id)
            }
            .store(in: &cancellables)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MovieTableViewCell.cellIdentifier
    }
}
