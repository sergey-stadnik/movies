//
//  MoviesViewModelProtocol.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import Foundation

protocol MoviesViewModelProtocol: ObservableObject {
    func fetchMovies()
}
