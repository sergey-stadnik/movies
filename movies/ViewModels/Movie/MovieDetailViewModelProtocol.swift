//
//  MovieDetailViewModelProtocol.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import Foundation

protocol MovieDetailViewModelProtocol: ObservableObject {
    var isAlertPresented: Bool { get set }
    var errorMessage: String? { get }

    var movie: MovieModel { get }

    func fetchMovie()
}
