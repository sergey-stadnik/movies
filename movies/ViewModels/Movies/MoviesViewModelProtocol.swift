//
//  MoviesViewModelProtocol.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import Foundation

protocol MoviesViewModelProtocol: ObservableObject {
    var movies: [MoviesModel] { get }
    var searchText: String { get set }
    var isAlertPresented: Bool { get set }
    var errorMessage: String? { get }

    func fetchMovies()

    func sortyByPrice()
    func sortByName()
}
