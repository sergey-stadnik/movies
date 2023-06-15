//
//  MoviesView.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import SwiftUI

struct MoviesView<ViewModelType: MoviesViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModelType

    @State private var showingAlert = false

    var body: some View {
        VStack {
            NavigationView {
                VStack(spacing: .zero) {
                    list()
                        .navigationTitle("Movies")
                }
                .toolbar {
                    sortingView()
                }

            }
            .searchable(text: $viewModel.searchText)
            .refreshable {
                viewModel.fetchMovies()
            }

        }
        .alert(viewModel.errorMessage ?? "", isPresented: $viewModel.isAlertPresented) {
            Button("OK", role: .cancel) {
                viewModel.isAlertPresented.toggle()
            }
        }
        .onAppear {
            viewModel.fetchMovies()
        }
    }
}

private extension MoviesView {
    func sortingView() -> some View {
        Menu(content: {
            Button("Price") {
                viewModel.sortyByPrice()
            }

            Button("Name") {
                viewModel.sortByName()
            }
        }, label: {
            Image(systemName: "list.bullet.rectangle")
        })
    }

    func list() -> some View {
        List(viewModel.movies) { movie in
            HStack {
                Text(movie.name)
                    .font(.system(.headline))

                Spacer()

                Text("$\(movie.price)")
                    .font(.system(.caption))
            }
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView(viewModel: MoviesViewModel())
    }
}
