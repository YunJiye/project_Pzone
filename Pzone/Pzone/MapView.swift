//
//  MapView.swift
//  Pzone
//
//  Created by J on 2022/10/21.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct MapView: View {
    @State var text : String = ""
    @State var refresh: Int = 0
    @State var tag: Int? = nil
    @State private var showingAlert: Bool = false
    @State private var isHome: Bool = false
    
    @State var startlat = GetInitialLocation.sharedInstance().latitude
    @State var startlon = GetInitialLocation.sharedInstance().longitude
    @State var showDetail = false
    
    var body: some View {
            ZStack {
                
                
                UIMapView(refresh: $refresh, startlat: $startlat, startlon: $startlon, showDetail: $showDetail)
                    .edgesIgnoringSafeArea(.vertical)
                    .frame(width: UIScreen.main.bounds.width)
                    .onAppear(perform: {
                        self.startlat = GetInitialLocation.sharedInstance().latitude
                        
                        self.startlon = GetInitialLocation.sharedInstance().longitude
                    })
                
                VStack {
                    Spacer(minLength: 630)
                    HStack {
                        Spacer(minLength: 380)
                        VStack(spacing: 10) {
                            Button(action: {
                                print("현재위치")
                                refresh += 1
                                
                            }, label: {
                                Image("Tracking")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                            }).buttonStyle(OptionButtonStyle())
                            NavigationLink(destination: SignInView(), isActive: $isHome){
                                Button(action: {
                                    print("홈으로")
                                    showingAlert.toggle()
                                    
                                }, label: {
                                    Image(systemName: "return")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }).buttonStyle(OptionButtonStyle())
                            }
                        }
                        Spacer(minLength: 40)
                    }
                    Spacer(minLength: 20)
                    
                }.sheet(isPresented: $showDetail) {
                    DetailView()
                }.alert(isPresented: $showingAlert) {
                    let secondButton = Alert.Button.cancel(Text("확인")) {
                        print("HI")
                        isHome = true
                        
                    }
                    return Alert(title: Text("홈으로 돌아가기"), message: Text("계정이 로그아웃됩니다. 계속하시겠습니까?"), primaryButton: .destructive(Text("취소"), action: {
                    }), secondaryButton: secondButton)
                }
            }
        }
}

struct UIMapView: UIViewRepresentable {
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
        print("****", startlat, startlon)
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: startlat, lng: startlon))
        cameraUpdate.animation = .easeIn
        view.moveCamera(cameraUpdate)
        
        let locationOverlay = view.locationOverlay
        locationOverlay.hidden = false
        locationOverlay.icon = NMFOverlayImage(name: "CarIcon")
        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO);
        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO);
        locationOverlay.location = NMGLatLng(lat: startlat, lng: startlon)
        
        
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

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}

struct SearchButtonStyle: ButtonStyle {
    var labelColor = Color.white
    var backgroundColor = Color("MainColor")
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 190, height: 70, alignment: .center)
            .foregroundColor(labelColor)
            .background(backgroundColor)
            .cornerRadius(1)
    }
}

struct OptionButtonStyle: ButtonStyle {
    var backgroundColor = Color.white
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(width: 40, height: 40, alignment: .center)
            .foregroundColor(.black)
            .background(backgroundColor)
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.lightgray, lineWidth: 1))
    }
}

extension Color {
    static let lightgray = Color(hex: "#2C3E50")
}
