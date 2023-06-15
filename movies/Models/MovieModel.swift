//
//  MovieModel.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import Foundation

struct MovieModel: MovieModelProtocol {
    let image: String
    let meta: String
    let name: String
    let price: Int
    let rating: String
    let synopsis: String
}

extension MovieModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.image = try container.decode(String.self, forKey: .image)
        self.meta = try container.decode(String.self, forKey: .meta)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Int.self, forKey: .price)
        self.rating = try container.decode(String.self, forKey: .rating)
        self.synopsis = try container.decode(String.self, forKey: .synopsis)
    }

    init() {
        self.image = ""
        self.meta = ""
        self.name = ""
        self.price = .zero
        self.rating = ""
        self.synopsis = ""
    }
}

private extension MovieModel {
    enum CodingKeys: String, CodingKey {
        case image, meta, name, price, rating, synopsis
    }
}
