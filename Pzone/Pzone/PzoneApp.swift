//
//  PzoneApp.swift
//  Pzone
//
//  Created by J on 2022/10/21.
//

import SwiftUI

@main
struct PzoneApp: App {
    
    init() {
            Thread.sleep(forTimeInterval: 2)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
            var plotInit = requestGetAllPlotss()
            var locInit = getInintialCoordinates()
        }
    }
}
