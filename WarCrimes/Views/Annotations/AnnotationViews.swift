//
//  AnnotationViews.swift
//  WarCrimes
//

import Foundation
import MapKit

class CrimeAnnotationView: MKMarkerAnnotationView {

    static let ReuseID = "crimeAnnotationView"

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        if let crimeAnnotation = annotation as? CrimeAnnotation {
            clusteringIdentifier = "crimeCluster-" + crimeAnnotation.eventId  // unique cluster for each event id.
        } else {
            clusteringIdentifier = "crimeCluster"
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForDisplay() {
        super.prepareForDisplay()
        displayPriority = .defaultLow

        guard let annotation = annotation as? CrimeAnnotation else { return }
        canShowCallout = true

        let label = UILabel.init()
        label.text = annotation.dateDescription
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 10)
        let view = UIView.init()
        label.fitIn(view)
        detailCalloutAccessoryView = view
    }
}


class CrimeClusterAnnotationView: MKAnnotationView {
    
    static let ReuseID = "crimeClusterAnnotationView"
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        collisionMode = .circle
        centerOffset = CGPoint(x: 0, y: -8)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let cluster = annotation as? MKClusterAnnotation {
            let count = cluster.memberAnnotations.count
            let color = ColorSet.colorsForEvents[(cluster.memberAnnotations.first as? CrimeAnnotation)!.eventId] ?? .systemBackground
            
            image = drawCircle(count: count, bg: color)
            
            displayPriority = count > 500 ? .defaultHigh: .defaultLow
        }
    }

    private func drawCircle(count: Int, bg: UIColor?) -> UIImage {
        
        var size = CGFloat.init(32)
        if count > 1000 {
            size = CGFloat.init(46)
        } else if count > 500 {
            size = CGFloat.init(42)
        } else if count > 100 {
            size = CGFloat.init(36)
        }
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: size, height: size))
        return renderer.image { _ in

            bg?.setFill()
            UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: size, height: size)).fill()

            let attributes = [ NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.8),
                               NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: size/2.5)]
            let text = "\(count)"
            let textSize = text.size(withAttributes: attributes)
            let rect = CGRect(x: (size/2) - (textSize.width / 2), y: (size/2) - (textSize.height / 2), width: textSize.width, height: textSize.height)
            text.draw(in: rect, withAttributes: attributes)
        }
    }

    
}
