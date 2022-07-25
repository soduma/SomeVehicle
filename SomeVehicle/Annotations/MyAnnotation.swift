//
//  MyAnnotation.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import UIKit
import MapKit

class MyAnnotation: NSObject, MKAnnotation {
    static let identifier = "MyAnnotation"
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
        
        super.init()
    }
}
