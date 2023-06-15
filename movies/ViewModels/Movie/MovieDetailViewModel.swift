//
//  MovieDetailViewModel.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import Foundation
import Combine

final class MovieDetailViewModel: MovieDetailViewModelProtocol {
    private(set) var networkService: NetworkServiceProtocol
    private(set) var cancellable = Set<AnyCancellable>()

    private let movieId: String
    @Published var movie: MovieModel = MovieModel()

    @Published var isAlertPresented: Bool = false
    var errorMessage: String?

    init(networkService: NetworkServiceProtocol = NetworkService(), id: String) {
        self.networkService = networkService
        self.movieId = id
    }

    func fetchMovie() {
        let publisher: AnyPublisher<MovieModel, MoviesError> = networkService.fetchMovie(movieId)

        publisher
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.isAlertPresented = true
                case .finished: break
                }
            } receiveValue: { [weak self] modelResult in
                guard let self = self else { return }
                self.movie = modelResult
            }.store(in: &cancellable)
    }
}
