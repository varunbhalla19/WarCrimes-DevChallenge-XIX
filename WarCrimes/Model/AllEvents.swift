//
//  AllEvents.swift
//  WarCrimes
//

import Foundation

struct AllEvents {
    
    var allEvents: [CrimeEvent]


    init(events: [CrimeEvent] = []) {
        self.allEvents = events
    }
    
    struct CrimeEventKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }

        static let from = CrimeEventKeys(stringValue: "from")!
        static let till = CrimeEventKeys(stringValue: "till")!
        static let id = CrimeEventKeys(stringValue: "id")!
        static let lat = CrimeEventKeys(stringValue: "lat")!
        static let lon = CrimeEventKeys(stringValue: "lon")!
        static let event = CrimeEventKeys(stringValue: "event")!
        static let qualification = CrimeEventKeys(stringValue: "qualification")!
        static let objectStatus = CrimeEventKeys(stringValue: "object_status")!
        static let affectedType = CrimeEventKeys(stringValue: "affected_type")!
    }

    
}

/*
 to decode json
 {
   id: { k1: v1, k2: v2 }
 }
 into
 class Example( id, v1, v2 )
 */

extension AllEvents: Decodable {
    public init(from decoder: Decoder) throws {
        var allEvents = [CrimeEvent].init()
        let container = try decoder.container(keyedBy: CrimeEventKeys.self)
        for key in container.allKeys {

            let productContainer = try container.nestedContainer(keyedBy: CrimeEventKeys.self, forKey: key)
            
            let from = try productContainer.decode(Date.self, forKey: .from)
            let till = try productContainer.decode(Date.self, forKey: .till)
            let id = key.stringValue
            
            let lat = try productContainer.decodeIfPresent(CGFloat.self, forKey: .lat)
            let lon = try productContainer.decodeIfPresent(CGFloat.self, forKey: .lon)
            let event = try productContainer.decodeIfPresent([String].self, forKey: .event)
            
            let status = try productContainer.decodeIfPresent([String].self, forKey: .objectStatus)
            
            // This removes inconsistent event data.            
            if( lat == nil || lon == nil || event == nil ) {
                continue
            }
            
            let qualification = try productContainer.decodeIfPresent([String].self, forKey: .qualification)
            let affected = try productContainer.decodeIfPresent([String].self, forKey: .affectedType)

            let product = CrimeEvent.init(from: from, till: till, id: id, lat: lat!, lon: lon!, event: event!, qualification: qualification, objectStatus: status, affectedType: affected)
            allEvents.append(product)
        }

        self.init(events: allEvents)
    }
}


