//
//  CrimeAnnotation.swift
//  WarCrimes
//

import MapKit

class CrimeAnnotation: NSObject, MKAnnotation {
    
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let eventId: String
    let dateDescription: String
    init(
        title: String?,
        coordinate: CLLocationCoordinate2D,
        eventId: String,
        dateDescription: String
    ) {
        self.title = title
        self.coordinate = coordinate
        self.eventId = eventId
        self.dateDescription = dateDescription
        super.init()
  }

  var subtitle: String? {
    return ""
  }
}
