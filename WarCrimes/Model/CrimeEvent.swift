//
//  Event.swift
//  WarCrimes
//

import Foundation

struct CrimeEvent{
    let from: Date
    let till: Date
    let id: String
    let lat: CGFloat
    let lon: CGFloat
    let event: [String]
    let qualification: [String]?
    let objectStatus: [String]?
    var name: String = ""
    let affectedType: [String]?
}
