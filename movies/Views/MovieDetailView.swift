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
        ScrollView {
            VStack {
                Text(viewModel.movie.name)
                    .font(.system(.largeTitle))
                AsyncImage(url: URL(string: viewModel.movie.image)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .cornerRadius(10)


                    Text(viewModel.movie.meta)
                        .padding(.top, 20)

                    Text(viewModel.movie.rating)

                    Text(viewModel.movie.synopsis)
                        .font(.system(.body))
                        .padding()

                    Text("$\(viewModel.movie.price)")
                        .font(.system(.largeTitle))
                        .padding(.top, 20)
                        .foregroundColor(.red)

                } placeholder: {
                    ProgressView()
                }
            }
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
