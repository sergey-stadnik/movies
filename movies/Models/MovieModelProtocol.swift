//
//  MovieModelProtocol.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

protocol MovieModelProtocol: Decodable {
    var image: String { get }
    var meta: String { get }
    var name: String { get }
    var price: Int { get }
    var rating: String { get }
    var synopsis: String { get }
}
