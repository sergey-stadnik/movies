//
//  NetworkServiceProtocol.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import Foundation
import Combine

enum HTTPMethod: String {
    case POST
    case PATCH
    case PUT
    case GET
    case DELETE
}

protocol NetworkServiceProtocol {
    func fetchMovies<NetworkResponse: MoviesModelProtocol>() -> AnyPublisher<[NetworkResponse], MoviesError>
    func fetchMovie<NetworkResponse: MovieModelProtocol>(_ id: String) -> AnyPublisher<NetworkResponse, MoviesError>
}
