//
//  Errors.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import Foundation

enum NetworkServiceError: Error {
    case noInternetConnection
    case internalServerError
    case invalidResponse
    case unknown(code: Int, error: String)
    case invalidJSON(_ error: String)
}

enum MoviesError: Error {
    case noInternetConnection
    case unowned
    case generic(NetworkServiceError)

    init(_ serviceError: NetworkServiceError) {
        switch serviceError {
        case .noInternetConnection:
            self = MoviesError.noInternetConnection
        default:
            self = .generic(serviceError)
        }
    }
}
