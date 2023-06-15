//
//  MoviesModel.swift
//  movies
//
//  Created by Sergii Stadnyk on 15.06.2023.
//

import Foundation

struct MoviesModel: MoviesModelProtocol {
    let id: String
    let name: String
    let price: Int
}

extension MoviesModel {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Int.self, forKey: .price)
    }
}

private extension MoviesModel {
    enum CodingKeys: String, CodingKey {
        case id, name, price
    }
}
