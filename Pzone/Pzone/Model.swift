//
//  User.swift
//  Pzone
//
//  Created by J on 2022/11/25.
//

import Foundation

struct User: Codable {
    let id: Int
    let uid: String
    let password: String
    let token: String
}

struct Plot: Codable, Identifiable {
    var id = UUID()
    var oid: Int
    var name: String
    var longitude: String
    var latitude: String
    var address: String
    
    enum Codingeys: String, CodingKey {
            case oid = "id"
            case name
            case longitude
            case latitude
            case address
    }
    
    init() {
        self.oid = 0
        self.name = ""
        self.longitude = ""
        self.latitude = ""
        self.address = ""
    }
    
    init(oid: Int, name:String, longitude:String, latitude: String, address: String) {
        self.oid = oid
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
    }
}
