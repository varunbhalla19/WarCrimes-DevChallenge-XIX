//
//  PieSlice.swift
//  WarCrimes
//
import SwiftUI

struct PieSlice: View {
    
     var center: CGPoint
     var radius: CGFloat
     var startDegree: Double
     var endDegree: Double
     var isTouched:  Bool
     var accentColor:  Color
     var separatorColor: Color
    
    var path: Path {
        Path.init { path in
            path.addArc(
                center: center,
                radius: radius,
                startAngle: Angle.degrees(startDegree),
                endAngle: Angle.degrees(endDegree),
                clockwise: false
            )
             path.addLine(to: center)
             path.closeSubpath()
        }
    }
     
     var body: some View {
         path
          .fill(accentColor)
          .overlay(path.stroke(separatorColor, lineWidth: 2))
          .scaleEffect(isTouched ? 1.05 : 1)
          .animation(Animation.spring())
     }
 }

// MARK: Previews
struct PieSlice_Previews: PreviewProvider {
    static var previews: some View {
        PieSlice(
            center: CGPoint(x: 100, y: 200), radius: 300, startDegree: 20, endDegree: 90, isTouched: true, accentColor: .orange, separatorColor: .black

        )
    }
}


// MARK: PieSliceData
struct PieSliceData {
     var startDegree: Double
     var endDegree: Double
}

