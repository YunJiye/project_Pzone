//
//  GetInitialLocation.swift
//  Pzone
//
//  Created by J on 2022/12/05.
//

import Foundation
import SwiftUI
import CoreLocation

class GetInitialLocation: ObservableObject {
    public var latitude: Double = 37.551114
    public var longitude: Double = 126.940938
    
    struct StaticInstance {
        static var instance: GetInitialLocation?
    }
    
    class func sharedInstance() -> GetInitialLocation {
        if(StaticInstance.instance == nil) {
            StaticInstance.instance = GetInitialLocation()
        }
        return StaticInstance.instance!
    }
}

func getInintialCoordinates() {
    
    let curlocation = LocationHelper.currentLocation
    GetInitialLocation.sharedInstance().latitude = curlocation.latitude
    GetInitialLocation.sharedInstance().longitude = curlocation.longitude
    print("INITIAL: ", GetInitialLocation.sharedInstance().latitude, GetInitialLocation.sharedInstance().longitude)
}
