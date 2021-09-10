//
//  Review.swift
//  SwiftUI-Movies_App
//
//  Created by Arpit Dixit on 10/09/21.
//

import Foundation

struct Review: Codable {
    var id: UUID?
    var title: String
    var body: String
    var movie: Movie?
}
