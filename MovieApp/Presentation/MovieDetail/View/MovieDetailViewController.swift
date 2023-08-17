//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by Ariel on 31/07/2023.
//

import Combine
import Nuke
import UIKit
import SwiftUI

protocol PoppableViewController {
    func popViewController()
    func toggleSubscription(for movie: Movie)
    func isSubscribed(to movie: Movie) -> Bool
}

class MovieDetailViewController: UIViewController {
    
    private var detailView: MovieDetailView = {
        let view = MovieDetailView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let backButton: UIImageView = {
        let backButton = UIImageView()
        backButton.backgroundColor = .black
        backButton.tintColor = .white
        backButton.image = UIImage(systemName: "arrow.left")?.withAlignmentRectInsets(.init(top: 2, left: 2, bottom: 2, right: 2))
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.layer.cornerRadius = 15
        backButton.contentMode = .center
        backButton.isUserInteractionEnabled = true
        return backButton
    }()
    
    var movie: Movie
    var delegate: PoppableViewController?
    var isSubscribed: Bool {
        didSet {
            delegate?.toggleSubscription(for: movie)
            updateSubscribedButton()
        }
    }
    
    init(movie: Movie, isSubscribed: Bool) {
        self.movie = movie
        self.isSubscribed = isSubscribed
        ImagePipeline.shared = ImagePipeline(configuration: .withDataCache)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setTapGestures()
        updateController()
    }
    
    func updateController() {
        updateUI(with: movie)
        updateSubscribedButton()
    }
    
    private func setUpView() {
        view.addSubview(detailView)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            detailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            backButton.heightAnchor.constraint(equalToConstant: 28.0),
            backButton.widthAnchor.constraint(equalToConstant: 28.0),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        ])
    }
    
    private func setTapGestures() {
        let backButtonGesture = UITapGestureRecognizer(target: self, action: #selector(backButtonTapped))
        backButton.addGestureRecognizer(backButtonGesture)
        
        let subscribeButtonGesture = UITapGestureRecognizer(target: self, action: #selector(subscribeButtonTapped))
        detailView.subscribeButton.addGestureRecognizer(subscribeButtonGesture)
    }
    
    private func updateSubscribedButton() {
        if isSubscribed {
            detailView.subscribeButton.textColor = self.detailView.primaryColor
            detailView.subscribeButton.backgroundColor = .white
            detailView.subscribeButton.text = "Suscripto".uppercased()
        } else {
            detailView.subscribeButton.textColor = .white
            detailView.subscribeButton.backgroundColor = .clear
            detailView.subscribeButton.text = "Suscribirme".uppercased()
        }
    }
    
    private func updateUI(with movie: Movie) {
        detailView.movieTitle.text = movie.title
        detailView.movieYear.text = movie.releaseDate
        
        if movie.overview.isEmpty {
            detailView.movieOverview.text = "<No overview>"
        } else {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            
            // let attributedString = NSMutableAttributedString(string: "\(movie.overview)\n\n\(movie.overview)")
            let attributedString = NSMutableAttributedString(string: "\(movie.overview)")
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
            detailView.movieOverview.attributedText = attributedString
        }

        detailView.moviePoster.isHidden = movie.posterPath == nil
        
        downloadPoster()
        
        if let url = movie.backdropPath {
            Task {
                let backdropImage = try await ImagePipeline.shared.image(for: url)
                
                UIView.animate(withDuration: 0.5) {
                    self.detailView.backgroundImageView.image = backdropImage
                    self.detailView.backgroundImageView.alpha = 1
                }
            }
        }
    }
    
    private func downloadPoster() {
        detailView.loader.isHidden = false
        
        guard let url = movie.posterPath else {
            hidePoster()
            displayComponents()
            return
        }
        
        Task {
            do {
                let posterImage = try await ImagePipeline.shared.image(for: url)
                detailView.moviePoster.isHidden = false
                UIView.animate(withDuration: 0.5) {
                    self.detailView.moviePoster.image = posterImage
                     self.detailView.primaryColor = (posterImage.prominentColor() ?? .white).withAlphaComponent(0.9)
                }
            } catch {
                hidePoster()
            }
            
            displayComponents()
        }
    }
    
    private func hidePoster() {
        detailView.moviePoster.isHidden = true
        detailView.primaryColor = .cyan.withAlphaComponent(0.9)
    }
    
    private func displayComponents() {
        detailView.loader.isHidden = true
        
        UIView.animate(withDuration: 0.5) {
            self.detailView.stackView.alpha = 1
            
            if self.isSubscribed {
                self.detailView.subscribeButton.textColor = self.detailView.primaryColor
            }
        }
    }

    @objc private func backButtonTapped() {
        delegate?.popViewController()
    }
    
    @objc private func subscribeButtonTapped() {
        isSubscribed.toggle()
    }
}
