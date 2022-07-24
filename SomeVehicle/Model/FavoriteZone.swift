//
//  FavoriteZone.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import Foundation

struct FavoriteZone: Codable, Equatable {
    let id: String
    let name: String
    let alias: String
    let latitude: String
    let longitude: String
}
