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
    private var savedMovies: [MoviesModel] = []
    private var savedSearchText = ""

    @Published var movies: [MoviesModel] = []
    @Published var isAlertPresented: Bool = false

    @Published var searchText: String = "" {
        didSet {
            filterMovies(searchText)
        }
    }

    var errorMessage: String?

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }

    func fetchMovies() {
        let publisher: AnyPublisher<[MoviesModel], MoviesError> = networkService.fetchMovies()

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
                self.movies = modelResult
                self.savedMovies = modelResult
            }.store(in: &cancellable)
    }

    func sortyByPrice() {
        movies = movies.sorted { $0.price < $1.price }
    }

    func sortByName() {
        movies = movies.sorted { $0.name < $1.name }
    }
}

private extension MoviesViewModel {
    func filterMovies(_ text: String) {
        if text.count < savedSearchText.count {
            movies = savedMovies
        }

        movies = movies.filter {
            String($0.price).contains(text)
        }

        savedSearchText = text

        if text.isEmpty {
            movies = savedMovies
        }
    }
}
