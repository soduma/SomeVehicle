//
//  ZoneAnnotation.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import UIKit
import MapKit

class ZoneAnnotation: NSObject, MKAnnotation {
    static let identifier = "ZoneAnnotation"
    @objc dynamic var coordinate: CLLocationCoordinate2D
    var id: String
    var name: String
    var alias: String
    
    init(coordinate: CLLocationCoordinate2D, id: String, name: String, alias: String) {
        self.coordinate = coordinate
        self.id = id
        self.name = name
        self.alias = alias
        
        super.init()
    }
}
