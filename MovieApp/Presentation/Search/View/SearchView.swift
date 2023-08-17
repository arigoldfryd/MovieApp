//
//  SearchView.swift
//  MovieApp
//
//  Created by Ariel on 02/08/2023.
//

import SwiftUI
import NukeUI

struct SearchView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var subscribed: SubscribedMovies
    @StateObject var viewModel: SearchViewModel
    @State private var searchText = ""
    
    init() {
        let viewModel = SearchViewModel()
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    #if TEST
    init(viewModel: SearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    #endif
    
    var body: some View {
        NavigationView {
            VStack {
                if let isEmpty = viewModel.movies?.isEmpty, viewModel.error != nil {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 40))
                    Text(isEmpty ? "No se encontraron resultados para \"\(searchText)\"" : "Algo salió mal. Reintentalo de nuevo.")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                } else if viewModel.movies != nil {
                    List {
                        ForEach(viewModel.movies!, id: \.self) { movie in
                            SearchCell(movie: movie)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .frame(height: 10)
                            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 4))
                        
                        TextField("Search", text: $searchText, onCommit: {
                            Task {
                                await viewModel.searchMovies(by: searchText)
                            }
                        }).foregroundColor(.primary)
                        
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill").opacity(searchText == "" ? 0 : 1)
                                .frame(height: 10)
                        }
                    }
                    .frame(height: 35)
                    .foregroundColor(.secondary)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10.0)
                }
            }
            .navigationTitle("Search")
            .navigationBarItems(trailing: Button("Cancel") {
                viewModel.cleanResults()
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
            .environmentObject(SubscribedMovies())
    }
}
