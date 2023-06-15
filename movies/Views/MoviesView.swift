//
//  MoviesView.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import SwiftUI

struct MoviesView<ViewModelType: MoviesViewModelProtocol>: View {
    @ObservedObject var viewModel: ViewModelType
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                viewModel.fetchMovies()
            }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView(viewModel: MoviesViewModel())
    }
}
