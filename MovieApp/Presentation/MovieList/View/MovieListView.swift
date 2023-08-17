//
//  ContentView.swift
//  MovieApp
//
//  Created by Ariel on 28/07/2023.
//

import SwiftUI
import NukeUI

struct MovieListView: View {
    let showFollowedMovies = false
    
    @StateObject var viewModel: MovieListViewModel
    @StateObject var subscribed: SubscribedMovies = SubscribedMovies()
    @State private var error: Error?

    init() {
        let viewModel = MovieListViewModel(discoveryService: DefaultMovieService(),
                                           genreService: DefaultGenreService(),
                                           movieMapper: DefaultMovieMapper())
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    #if TEST
    init(viewModel: MovieListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    #endif
    
    var body: some View {
        NavigationStack {
            List {
                if !subscribed.movies.isEmpty {
                    Text("Series que sigo")
                        .font(.headline)
                        .textCase(.uppercase)
                        .listRowSeparator(.hidden)
                        .offset(x: -10)
                    
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 16) {
                            ForEach(subscribed.movies, id: \.self) { movie in
                                NavigationLink {
                                    MovieDetailViewWrapper(movie: movie)
                                        .edgesIgnoringSafeArea(.vertical)
                                        .navigationBarBackButtonHidden()
                                } label: {
                                    LazyImage(url: movie.posterPath) { state in
                                        if let image = state.image {
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fill)
                                        } else if state.error != nil {
                                            Image(systemName: "wifi.slash")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 20, height: 20)
                                                .foregroundColor(.white)
                                        } else {
                                            ProgressView()
                                        }
                                    }
                                    .frame(width: 130, height: 180, alignment: .center)
                                    .background(.gray)
                                    .cornerRadius(8)
                                }
                                .shadow(color: .black.opacity(0.8), radius: 2, x: 1, y: 1)
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.trailing)
                    }
                    .offset(x: -10)
                    .scrollIndicators(.hidden)
                }
                
                if viewModel.error == nil {
                    Text("Recomendadas")
                        .font(.headline)
                        .textCase(.uppercase)
                        .listRowSeparator(.hidden)
                        .offset(x: -10)
                    
                    ForEach(viewModel.movies, id: \.id) { movie in
                        RecommendedMoviesView(movie: movie)
                            .onAppear {
                                if movie == viewModel.movies.last {
                                    Task {
                                        await viewModel.getMovies()
                                    }
                                }
                            }
                    }
                    .listRowSeparator(.hidden)
                    
                } else {
                    Text("Hubo un problema en cargar las peliculas. Recargá y probá de nuevo :)")
                }
                
            }
            
            .refreshable {
                Task {
                    await viewModel.getMovies()
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink {
                        SearchView().navigationBarBackButtonHidden()
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.black)
                    }.isDetailLink(false)
                }
                ToolbarItem(placement: .principal) {
                    Text("TV Movie Reminder")
                        .font(.headline)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            Task {
                await viewModel.getMovies()
            }
        }
        .environmentObject(subscribed)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}

extension View {

    @ViewBuilder
    public func `if`<T: View, U: View>(
        _ condition: Bool,
        then modifierT: (Self) -> T,
        else modifierU: (Self) -> U
    ) -> some View {

        if condition { modifierT(self) }
        else { modifierU(self) }
    }
}
