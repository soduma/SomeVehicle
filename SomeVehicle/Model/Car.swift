//
//  Car.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import Foundation

struct Car: Codable, Equatable {
    let id: String
    let name: String
    let description: String
    let imageUrl: String
    let category: String
    let zones: [String]
    
    var newCatagory: String {
        switch category {
        case "EV":
            return "전기"
        case "COMPACT":
            return "소형"
        case "COMPACT_SUV":
            return "소형 SUV"
        case "SEMI_MID_SUV":
            return "준중형 SUV"
        case "SEMI_MID_SEDAN":
            return "준중형 세단"
        case "MID_SUV":
            return "중형 SUV"
        case "MID_SEDAN":
            return "중형 세단"
        default:
            return ""
        }
    }
}
