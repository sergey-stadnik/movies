//
//  MovieDetailView.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import SwiftUI

struct MovieDetailView<ViewModelType: MovieDetailViewModelProtocol>: View {
    @StateObject var viewModel: ViewModelType

    @State private var showingAlert = false

    var body: some View {
        VStack {
            Text(viewModel.movie.name)
        }
        .alert(viewModel.errorMessage ?? "", isPresented: $viewModel.isAlertPresented) {
            Button("OK", role: .cancel) {
                viewModel.isAlertPresented.toggle()
            }
        }
        .onAppear {
            viewModel.fetchMovie()
        }
    }
}

struct MovieDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailView(viewModel: MovieDetailViewModel(id: UUID().uuidString))
    }
}
