//
//  NetworkManager.swift
//  SomeVehicle
//
//  Created by 장기화 on 2022/07/25.
//

import Foundation
import Alamofire

class NetworkManager {
    func getZones() async -> Result<[Zone], AFError> {
        let url = "http://localhost:3000/zones"
        let data = await AF.request(url, method: .get)
            .serializingDecodable([Zone].self).result
        return data
    }
    
    func getCarsInZone(zone: String) async -> Result<[Car], AFError> {
        let url = "http://localhost:3000/cars?zones_like=\(zone)"
        let data = await AF.request(url, method: .get)
            .serializingDecodable([Car].self).result
        return data
    }
}
