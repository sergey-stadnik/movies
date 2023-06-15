//
//  NetworkService.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import Combine
import Foundation

class NetworkService: NetworkServiceProtocol {
    private let urlSession: URLSession
    private let baseURL = "https://us-central1-testmodule-12b1c.cloudfunctions.net"
    private let timeout: Float =  30.0

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    // MARK: Movies

    func fetchMovies<NetworkResponse>() -> AnyPublisher<[NetworkResponse], MoviesError> where NetworkResponse : MoviesModelProtocol {
        requestList(with: moviesListRequest())
            .mapError { MoviesError($0) }
            .eraseToAnyPublisher()
    }

    func fetchMovie<NetworkResponse>(_ id: String) -> AnyPublisher<NetworkResponse, MoviesError> where NetworkResponse : MovieModelProtocol {
        request(with: movieRequest(id: id))
            .mapError { MoviesError($0) }
            .eraseToAnyPublisher()
    }
}

// MARK: Request builders

private extension NetworkService {
    func moviesListRequest() -> URLRequest {
        let url = URL(string: "\(baseURL)/movies")!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.allHTTPHeaderFields = buildDefaultHTTPHeaderFields()
        return request
    }

    func movieRequest(id: String) -> URLRequest {
        let url = URL(string: "\(baseURL)/movieDetails?id=\(id)")!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.GET.rawValue
        request.allHTTPHeaderFields = buildDefaultHTTPHeaderFields()
        return request
    }

    func buildDefaultHTTPHeaderFields() -> [String : String]? {
        var headers: [String : String] = [:]
        headers["Content-Type"] = "application/json"
        return headers
    }
}

// MARK: Base

private extension NetworkService {
    func requestList<NetworkResponse>(with urlRequest: URLRequest) -> AnyPublisher<[NetworkResponse], NetworkServiceError> where NetworkResponse: Decodable {
        return requestData(urlRequest: urlRequest)
            .decode(type: [NetworkResponse].self, decoder: JSONDecoder())
            .mapError{ ($0 as? NetworkServiceError) ?? NetworkServiceError.invalidJSON($0.localizedDescription) }
            .eraseToAnyPublisher()
    }

    func request<NetworkResponse>(with urlRequest: URLRequest) -> AnyPublisher<NetworkResponse, NetworkServiceError> where NetworkResponse: Decodable {
        return requestData(urlRequest: urlRequest)
            .decode(type: NetworkResponse.self, decoder: JSONDecoder())
            .mapError{ ($0 as? NetworkServiceError) ?? NetworkServiceError.invalidJSON($0.localizedDescription) }
            .eraseToAnyPublisher()
    }

    func requestData(urlRequest: URLRequest) -> AnyPublisher<Data, NetworkServiceError> {
        urlSession.configuration.timeoutIntervalForRequest = TimeInterval(timeout)

        return urlSession
            .dataTaskPublisher(for: urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { error -> NetworkServiceError in
                switch error.errorCode {
                case NSURLErrorNotConnectedToInternet,
                    NSURLErrorNetworkConnectionLost,
                NSURLErrorInternationalRoamingOff:
                    return NetworkServiceError.noInternetConnection
                default:
                    return NetworkServiceError.unknown(code: error.errorCode, error: error.localizedDescription)
                }
            }
            .flatMap { data, response -> AnyPublisher<Data, NetworkServiceError> in
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: NetworkServiceError.invalidResponse)
                        .eraseToAnyPublisher()
                }

                let statusCode = response.statusCode

                guard (200...299).contains(statusCode) else {
                    switch statusCode {
                    case 500:
                        return Fail(error: NetworkServiceError.internalServerError).eraseToAnyPublisher()
                    default:
                        return Fail(error: NetworkServiceError.invalidResponse).eraseToAnyPublisher()
                    }
                }

                return Future<Data, NetworkServiceError> { promise in
                    promise(.success(data))
                }
                .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
}
