//
//  Zone.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import Foundation

struct Zone: Codable {
    let id: String
    let name: String
    let alias: String
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}
