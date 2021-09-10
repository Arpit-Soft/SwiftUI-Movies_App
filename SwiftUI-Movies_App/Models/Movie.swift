//
//  Movie.swift
//  SwiftUI-Movies_App
//
//  Created by Arpit Dixit on 10/09/21.
//

import Foundation

struct Movie: Codable {
    var id: UUID?
    var title: String
    var poster: String
    
    private enum MovieKeys: String, CodingKey {
        case id
        case title
        case poster
    }
    
}

extension Movie {
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: MovieKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.poster = try container.decode(String.self, forKey: .poster)
    }
    
}

