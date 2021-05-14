//
//  Student.swift
//  assignment3
//
//  Created by Connor Zhao on 30/4/21.
//

import Foundation

public struct Student: Codable {
    var id: String?
    var studentName: String
    var studentID: Int
    var avatar: Data?
    var grades: [String: Double]
}
