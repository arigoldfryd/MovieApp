//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Ariel on 31/07/2023.
//

import UIKit

class MovieDetailView: UIView {
    var primaryColor: UIColor = .white {
        didSet {
            backgroundView.backgroundColor = primaryColor
            primaryTextColor = primaryColor.getHigherContrast()
        }
    }
    
    var primaryTextColor: UIColor = .black {
        didSet {
            movieTitle.textColor = primaryTextColor
            movieYear.textColor = primaryTextColor
            movieOverview.textColor = primaryTextColor
            overviewTitle.textColor = primaryTextColor
        }
    }
    
    var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alpha = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 0
        return stackView
    }()
    
    var moviePoster: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .red
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var movieTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    var movieYear: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .white
        return textView
    }()
    
    var subscribeButton: UILabel = {
        let button = UILabel()
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.font = UIFont.boldSystemFont(ofSize: 16)
        button.textAlignment = .center
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        return button
    }()
    
    private let overviewTitle: UILabel = {
        let label = UILabel()
        label.text = "Overview".uppercased()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    var movieOverview: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.numberOfLines = 0
        return textView
    }()
    
    var loader: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.color = .white
        return view
    }()
    
    override func layoutSubviews() {
        setSubviews()
    }
    
    private func setSubviews() {
        stackView.addArrangedSubview(moviePoster)
        stackView.addArrangedSubview(movieTitle)
        stackView.addArrangedSubview(movieYear)
        stackView.addArrangedSubview(subscribeButton)
        stackView.addArrangedSubview(overviewTitle)
        stackView.addArrangedSubview(movieOverview)
        
        stackView.setCustomSpacing(24, after: moviePoster)
        stackView.setCustomSpacing(4, after: movieTitle)
        stackView.setCustomSpacing(24, after: movieYear)
        stackView.setCustomSpacing(48, after: subscribeButton)
        stackView.setCustomSpacing(16, after: overviewTitle)
        
        addSubview(backgroundImageView)
        addSubview(backgroundView)
        
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        addSubview(loader)
        loader.startAnimating()
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            subscribeButton.widthAnchor.constraint(equalToConstant: 200),
            subscribeButton.heightAnchor.constraint(equalToConstant: 45),
            
            moviePoster.widthAnchor.constraint(equalToConstant: 200),
            moviePoster.heightAnchor.constraint(equalToConstant: 200 * 1.5),
            
            movieTitle.leadingAnchor.constraint(equalTo: stackView.leadingAnchor, constant: 8),
            movieTitle.trailingAnchor.constraint(equalTo: stackView.trailingAnchor, constant: -8),
            
            overviewTitle.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        subscribeButton.layoutIfNeeded()
        subscribeButton.layer.cornerRadius = subscribeButton.frame.height / 2
    }
}
