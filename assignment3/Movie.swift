//
//  Movie.swift
//  assignment3
//
//  Created by Connor Zhao on 30/4/21.
//

import Foundation
public struct Movie: Codable {
    var id: String?
    var title: String
    var year: Int32
    var duration: Float
}
