//
//  RecommendedMovieView.swift
//  MovieApp
//
//  Created by Ariel on 28/07/2023.
//

import SwiftUI
import NukeUI

struct RecommendedMoviesView: View {
    let firstColor = Color(UIColor(hex: "#091920")!)
    let secondColor = Color(UIColor(hex: "#3c5663")!)
    
    @State var movie: Movie
    
    var body: some View {
        VStack {
            let bottomLeadingText = HStack {
                Text(movie.title)
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                    .offset(x: -10, y: 10)
                    .padding(8)
                Spacer()
            }.padding()
            
            let topTrailingText = HStack {
                if let name = movie.genres.first?.name {
                    Spacer()
                    Text(name)
                        .font(.caption)
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .bold()
                        .padding(8)
                        .background(.black.opacity(0.6))
                        .cornerRadius(8)
                        .offset(x: 5)
                    
                }
            }.padding()
            
            VStack {
                LazyImage(url: movie.backdropPath, transaction: Transaction(animation: .easeIn(duration: 0.5))) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .overlay(
                                .linearGradient(colors: [firstColor, secondColor], startPoint: .bottom, endPoint: .top)
                                .opacity(0.5)
                            )
                            .scaledToFill()
                    } else if state.error != nil {
                        EmptyView()
                    } else {
                        ProgressView()
                    }
                }
                .frame(width: 380, height: 200, alignment: .center)
                .background(.linearGradient(colors: [firstColor, secondColor], startPoint: .bottom, endPoint: .top))
                .cornerRadius(4)
            }
            .overlay(topTrailingText, alignment: .top)
            .overlay(bottomLeadingText, alignment: .bottom)
            .background(
                NavigationLink("", destination: MovieDetailViewWrapper(movie: movie)
                    .edgesIgnoringSafeArea(.vertical)
                    .navigationBarBackButtonHidden()
                )
                .buttonStyle(.plain)
            )
        }
    }
}

