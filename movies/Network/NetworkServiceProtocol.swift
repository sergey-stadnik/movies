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
    func listOfMovies() -> AnyPublisher<Data, MoviesError>
    func movie(_ id: String) -> AnyPublisher<Data, MoviesError>
}
