//
//  Names.swift
//  WarCrimes
//

import Foundation

struct Names: Codable {
    let affected_type: [String: String]
    let object_status: [String: String]
    let event: [String: String]
    let qualification: [String: String]
}
