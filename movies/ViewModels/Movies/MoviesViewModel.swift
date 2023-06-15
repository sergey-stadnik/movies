//
//  MoviesViewModel.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import Foundation
import Combine

final class MoviesViewModel: MoviesViewModelProtocol {
    private(set) var networkService: NetworkServiceProtocol
    private(set) var cancellable = Set<AnyCancellable>()

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchMovies() {
        let publisher: AnyPublisher<Data, MoviesError> = networkService.listOfMovies()

        publisher
            .sink { [weak self] result in
                switch result {
                case .failure(let error):
                    // TODO: Handle error
                    break
                case .finished: break
                }
            } receiveValue: { [weak self] modelResult in
                guard let self = self else { return }
                print("result")
            }.store(in: &cancellable)
    }
}
