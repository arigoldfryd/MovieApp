//
//  SearchCellView.swift
//  MovieApp
//
//  Created by Ariel on 02/08/2023.
//

import SwiftUI
import NukeUI

struct SearchCell: View {
    
    @EnvironmentObject var subscribed: SubscribedMovies
    var movie: Movie

    var body: some View {
        NavigationLink(destination: MovieDetailViewWrapper(movie: movie)
            .edgesIgnoringSafeArea(.vertical)
            .navigationBarBackButtonHidden()
        ) {
            HStack {
                HStack {
                    if let url = movie.posterPath {
                        LazyImage(url: url) { state in
                            if let image = state.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .shadow(color: .black.opacity(0.8), radius: 2, x: 1, y: 1)
                            } else if state.error != nil {
                                Color.gray
                            } else {
                                ProgressView()
                            }
                        }
                    } else {
                        Color.gray
                    }
                }
                .frame(width: 48, height: 72, alignment: .center)
                .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 6) {
                    Text(movie.title)
                        .font(.system(size: 18))
                        .bold()
                    
                    if let genre = movie.genres.first?.name.uppercased() {
                        Text(genre)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Button(action: {
                    if subscribed.contains(movie) {
                        subscribed.remove(movie)
                    } else {
                        subscribed.add(movie)
                    }
                }) {
                    Text(subscribed.contains(movie) ? "AGREGADO" : "AGREGAR")
                        .font(.system(size: 12))
                        .padding(8)
                        .font(.body)
                        .foregroundColor(.gray)
                        .cornerRadius(4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(.gray, lineWidth: 2)
                        )
                }
            }
            .padding(4)
        }
        .isDetailLink(false)
        .buttonStyle(.plain)
        
    }
}

protocol SearchCellDelegate {
    func toggleSubscription(for movie: Movie)
}
