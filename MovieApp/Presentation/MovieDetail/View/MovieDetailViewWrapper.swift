//
//  MovieDetailViewWrapper.swift
//  MovieApp
//
//  Created by Ariel on 31/07/2023.
//

import Combine
import SwiftUI

struct MovieDetailViewWrapper: UIViewControllerRepresentable {
    typealias UIViewControllerType = MovieDetailViewController
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var subscribed: SubscribedMovies
    var movie: Movie
    
    
    func makeUIViewController(context: Context) -> MovieDetailViewController {
        let viewController = MovieDetailViewController(movie: movie, isSubscribed: subscribed.contains(movie))
        viewController.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: MovieDetailViewController, context: Context) {
        
    }
    
    func isSubscribed(to movie: Movie) -> Bool {
        subscribed.contains(movie)
    }
    
    func toggleSubscription(for movie: Movie) {
        if subscribed.contains(movie) {
            subscribed.remove(movie)
        } else {
            subscribed.add(movie)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

extension MovieDetailViewWrapper {
    class Coordinator: NSObject, PoppableViewController {
        var parent: MovieDetailViewWrapper
        
        init(_ parent: MovieDetailViewWrapper) {
            self.parent = parent
        }
        
        func popViewController() {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func toggleSubscription(for movie: Movie) {
            parent.toggleSubscription(for: movie)
        }
        
        func isSubscribed(to movie: Movie) -> Bool {
            parent.isSubscribed(to: movie)
        }
    }
}
