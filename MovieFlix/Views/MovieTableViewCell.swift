//
//  MovieTableViewCell.swift
//  MovieFlix
//
//  Created by Vasilis Polyzos on 1/2/24.
//

import UIKit
import Combine


class MovieTableViewCell: UITableViewCell {
    
    
    @IBOutlet private var containerView: UIView!
    @IBOutlet private var bannerView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    @IBOutlet private var releaseDateLabel: UILabel!
    @IBOutlet private var favoriteImage: UIImageView!
    let addMovieToFavoritesSubject = PassthroughSubject<Int, Never>()
    let removeMovieToFavoritesSubject = PassthroughSubject<Int, Never>()
    let didTapMovieSubject = PassthroughSubject<Int, Never>()
    
    var viewModel: MovieTableViewCellModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
    }
    
    func setupCell(with data: MovieTableViewCellModel) {
        self.viewModel = data
        containerView.bordered(color: UIColor.orange, borderWidth: 3.0)
        containerView.rounded(cornerRadius: 16)
        favoriteImage.image = UIImage(named: (data.isFavorite ?? false) ? "Heart" : "Heart_g")
        titleLabel.text = data.title
        releaseDateLabel.text = formatDate(inputDateString: data.releaseDate ?? "")
        setupContainerAction()
        setupFavoriteAction()
        Task {
            await setupBanner()
        }
        
    }
    
    func setupContainerAction() {
        containerView.tappable = true
        containerView.didTapped = { [weak self] in
            guard let self else { return }
            self.didTapMovieSubject.send(self.viewModel?.id ?? 0)
        }
    }
    
    func setupFavoriteAction() {
        favoriteImage.tappable = true
        favoriteImage.didTapped = { [weak self] in
            guard let self else { return }
            self.viewModel?.isFavorite?.toggle()
            if let status = self.viewModel?.isFavorite {
                if status {
                    self.addMovieToFavoritesSubject.send(self.viewModel?.id ?? 0)
                } else {
                    self.removeMovieToFavoritesSubject.send(self.viewModel?.id ?? 0)
                }
            }
            self.favoriteImage.image = UIImage(named: (self.viewModel?.isFavorite ?? false) ? "Heart" : "Heart_g")
        }
    }
    
    func setupBanner() async {
        let placeholderImage = UIImage(named: "Heart")
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = containerView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.withAlphaComponent(0.05).cgColor, UIColor.black.withAlphaComponent(0.2).cgColor,  UIColor.black.cgColor]
        bannerView.layer.insertSublayer(gradientLayer, at: 0)
        guard let url = URL(string: viewModel?.banner ?? "") else { return }
        bannerView.imageFromServerURL(viewModel?.banner ?? "", placeHolder: placeholderImage)
        bannerView.contentMode = .scaleAspectFill
    }
}


extension UIImageView {
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        self.image = nil
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    DispatchQueue.main.async { [weak self] in
                        guard let self else { return }
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            
                            self.image = downloadedImage
                        }
                    }
                }
            }).resume()
        }
    }
}

extension MovieTableViewCell {
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
