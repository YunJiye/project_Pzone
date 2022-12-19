//
//  SearchMapView.swift
//  Pzone
//
//  Created by J on 2022/12/05.
//

import Foundation
import SwiftUI
import NMapsMap
import CoreLocation


struct SearchMapView: View {
    @State var text : String = ""
    @State var refresh: Int = 0
    @State var tag: Int? = nil
    
    @Binding var startlat: Double
    @Binding var startlon: Double
    @State var showDetail = false
    
    var body: some View {
        
        ZStack {
            UISearchMapView(refresh: $refresh, startlat: $startlat, startlon: $startlon, showDetail: $showDetail)
                .edgesIgnoringSafeArea(.vertical)
                .frame(width: UIScreen.main.bounds.width)
                .onAppear(perform: {
                    self.startlat = NumberFormatter().number(from: GetCoordinates.sharedInstance().latitude)?.doubleValue ?? 37.551114
                    
                    self.startlon = NumberFormatter().number(from: GetCoordinates.sharedInstance().longitude)?.doubleValue ?? 126.940938
                    print(startlat, startlon)
                }).sheet(isPresented: $showDetail) {
                    DetailView()
                }
        }
    }
    
}

struct UISearchMapView: UIViewRepresentable {
    @Binding var refresh: Int
    
    @Binding var startlat: Double
    @Binding var startlon: Double
    
    @Binding var showDetail: Bool
    
    func makeUIView(context: Context) -> NMFMapView {
        /*
         let view = NMFNaverMapView()
         view.showZoomControls = false
         view.mapView.positionMode = .direction
         view.mapView.zoomLevel = 17
         
         return view
         */
        let view = NMFMapView()
        let lat = NumberFormatter().number(from: GetCoordinates.sharedInstance().latitude)?.doubleValue ?? 37.551114
        
        let lon = NumberFormatter().number(from: GetCoordinates.sharedInstance().longitude)?.doubleValue ?? 126.940938
        print("HERE", lat, lon)
        print("HERE", GetCoordinates.sharedInstance().latitude, GetCoordinates.sharedInstance().longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lon))
        cameraUpdate.animation = .easeIn
        view.moveCamera(cameraUpdate)
        
        let locationOverlay = view.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.icon = NMFOverlayImage(name: "CarIcon")
        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO);
        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO);
        locationOverlay.location = NMGLatLng(lat: lat, lng: lon)
        
        
        let plot_list = GetPlots.sharedInstance().p_list

        for i in 0..<plot_list.count {
            let marker = NMFMarker()
            let latitude = NumberFormatter().number(from: plot_list[i].latitude)?.doubleValue
            let longitude = NumberFormatter().number(from: plot_list[i].longitude)?.doubleValue
            print(plot_list[i].name, plot_list[i].latitude, plot_list[i].longitude)
            marker.position = NMGLatLng(lat: latitude!, lng: longitude!)
            marker.userInfo = ["placeId": plot_list[i].name]
            marker.captionText = plot_list[i].name
            marker.captionTextSize = 16
            marker.captionAligns = [NMFAlignType.top]
            marker.touchHandler = { (overlay) -> Bool in
                print("마커 터치")
                print(overlay.userInfo["placeId"] as! String)
                GetPlot.sharedInstance().p.id = plot_list[i].id
                GetPlot.sharedInstance().p.name = plot_list[i].name
                GetPlot.sharedInstance().p.address = plot_list[i].address
                GetPlot.sharedInstance().p.latitude = plot_list[i].latitude
                GetPlot.sharedInstance().p.longitude = plot_list[i].longitude
                GetPlots.sharedInstance().selected_p = overlay.userInfo["placeId"] as! String
                showDetail = true
                return true
            }
            marker.mapView = view
            
        }
        
        return view
        
    }
    
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
        if(refresh != 0) {
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: startlat, lng: startlon))
            
            uiView.moveCamera(cameraUpdate)
        }
    }
    
}

struct SearchMapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
