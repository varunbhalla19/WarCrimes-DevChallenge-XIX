//
//  ColorSet.swift
//  WarCrimes
//

import UIKit

/*
 Color values for each event in the names.json.
 */

struct ColorSet {
    static let colors: [UIColor] = Self.colorsValues.map { (r, g, b) in UIColor.init(
        red: CGFloat.init(r)/255, green: CGFloat.init(g)/255, blue: CGFloat.init(b)/255, alpha: 1
    ) }
    private static let colorsValues: [(Int, Int, Int)] = [
        (128,0,0),
        (25,25,112),
        (165,42,42),
        (220,20,60),
        (255,127,80),
        (233,150,122),
        (255,69,0),
        (189,183,107),
        (128,128,0),
        (0,100,0),
        (47,79,79),
        (0,139,139),
        (100,149,237),
        (138,43,226),
        (72,61,139),
        (139,0,139),
        (188,143,143),
        (112,128,144),
        (105,105,105),
        (210,180,140),
        (160,82,45),
        (255,20,147),
        (199,21,133),
        (128,0,128),
        (65,105,225),
        (128,128,128),
        (60,80,60),
        (12,128,44),
        (55,250,205)
    ]
    
    static let colorsForEvents: [String: UIColor] = [
        "5": UIColor.fromTriplet((128,0,0)),
        "6": UIColor.fromTriplet( (25,25,112)),
        "7": UIColor.fromTriplet( (233,150,122)),
        "8": UIColor.fromTriplet( (189,183,107)),
        "9": UIColor.fromTriplet( (0,139,139)),
        "10": UIColor.fromTriplet((100,149,237) ),
        "11": UIColor.fromTriplet( (165,42,42) ),
        "12": UIColor.fromTriplet( (138,43,226)),
        "34": UIColor.fromTriplet( (72,61,139)),
        "35": UIColor.fromTriplet( (139,0,139)),
        "36": UIColor.fromTriplet( (188,143,143)),
        "37": UIColor.fromTriplet( (112,128,144)),
        "38": UIColor.fromTriplet( (210,180,140)),
        "39": UIColor.fromTriplet((160,82,45) ),
        "40": UIColor.fromTriplet( (255,20,147)),
        "41": UIColor.fromTriplet((199,21,133) ),
        "42": UIColor.fromTriplet((128,0,128) ),
        "43": UIColor.fromTriplet( (65,105,225)),
        "44": UIColor.fromTriplet( (60,80,60)),
        "45": UIColor.fromTriplet((12,128,44) ),
        "47": UIColor.fromTriplet((55,250,205)),
    ]
    
    static let colorsForQualifications: [String: UIColor] = [
        "1": UIColor.fromTriplet((12,128,44) ),
        "2": UIColor.fromTriplet((55,250,205)),
        "3": UIColor.fromTriplet( (65,105,225)),
        "4": UIColor.fromTriplet( (60,80,60)),
        "5": UIColor.fromTriplet((199,21,133) ),
        "7": UIColor.fromTriplet((128,0,128) ),
        "8": UIColor.fromTriplet((160,82,45) ),
        "9": UIColor.fromTriplet( (255,20,147)),
        "10": UIColor.fromTriplet( (112,128,144)),
        "11": UIColor.fromTriplet( (210,180,140)),
        "14": UIColor.fromTriplet( (139,0,139)),
        "15": UIColor.fromTriplet( (188,143,143)),
        "16": UIColor.fromTriplet( (138,43,226)),
        "17": UIColor.fromTriplet( (72,61,139)),
        "18": UIColor.fromTriplet((100,149,237) ),
        "21": UIColor.fromTriplet( (165,42,42) ),
        "22": UIColor.fromTriplet( (189,183,107)),
        "23": UIColor.fromTriplet( (0,139,139)),
        "24": UIColor.fromTriplet( (25,25,112)),
        "25": UIColor.fromTriplet( (233,150,122)),
        "26": UIColor.fromTriplet((128,0,0)),
        "27": UIColor.fromTriplet( (12,128,44)),
        "29": UIColor.fromTriplet((128,128,128) ),
        "30": UIColor.fromTriplet( (55,120,147)),
        "32": UIColor.fromTriplet( (38,43,26)),
        "33": UIColor.fromTriplet( (238,43,206)),
        "34": UIColor.fromTriplet( (88,143,96)),
        "35": UIColor.fromTriplet( (192,168,116))
    ]
    
    static let colorsForStatus: [String: UIColor] = [
        "2": UIColor.fromTriplet( (128,0,0) ),
        "3": UIColor.fromTriplet( (65,105,225) ),
        "5": UIColor.fromTriplet((199,21,133) ),
        "6": UIColor.fromTriplet( (0,128,0) ),
        "7": UIColor.fromTriplet( (155,155,0) ),
        "8": UIColor.fromTriplet((160,82,45) ),
        "9": UIColor.fromTriplet( (255,20,147)),
        "10": UIColor.fromTriplet( (112,128,144)),
        "12": UIColor.fromTriplet( (210,180,140)),
        "13": UIColor.fromTriplet( (139,0,139)),
        "14": UIColor.fromTriplet( (188,143,143)),
        "15": UIColor.fromTriplet( (138,43,226)),
        "16": UIColor.fromTriplet( (72,61,139)),
        "18": UIColor.fromTriplet((100,149,237) ),
        "19": UIColor.fromTriplet( (189,183,107)),
    ]
    
    static let colorsForAffected: [String: UIColor] = [
        "2": UIColor.fromTriplet((138,43,226)),
        "3": UIColor.fromTriplet( (95,158,160)),
        "5": UIColor.fromTriplet( (218,165,32) ),
        "6": UIColor.fromTriplet( (205,92,92) ),
        "4": UIColor.fromTriplet( (0,100,0) ),
    ]
    
}

extension UIColor {
    
    class func fromTriplet(_ triplet: (CGFloat, CGFloat, CGFloat)) -> UIColor {
        UIColor.init(red: triplet.0/255, green: triplet.1/255, blue: triplet.2/255, alpha: 1.0)
    }
    
}
