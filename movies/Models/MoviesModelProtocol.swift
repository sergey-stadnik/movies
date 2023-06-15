//
//  MoviesModelProtocol.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

protocol MoviesModelProtocol: Decodable {
    var id: String { get }
    var name: String { get }
    var price: Int { get }
}
