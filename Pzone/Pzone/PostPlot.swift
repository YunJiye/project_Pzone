//
//  PostPlot.swift
//  Pzone
//
//  Created by J on 2022/12/11.
//

import Foundation
import SwiftUI
import SwiftyJSON

struct PlotForList: Codable {
    var oid: String
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
        self.oid = ""
        self.name = ""
        self.longitude = ""
        self.latitude = ""
        self.address = ""
    }
    
    init(oid: String, name:String, longitude:String, latitude: String, address: String) {
        self.oid = oid
        self.name = name
        self.longitude = longitude
        self.latitude = latitude
        self.address = address
    }
}

class OwnerPlotList {
    public var id = UUID()
    public var pList: [PlotForList] = []
    
    struct StaticInstance {
        static var instance: OwnerPlotList?
    }
    
    class func sharedInstance() -> OwnerPlotList {
        if(StaticInstance.instance == nil) {
            StaticInstance.instance = OwnerPlotList()
        }
        return StaticInstance.instance!
    }
}

class OwnerPlot: ObservableObject {
    public var id = UUID()
    public var owner: String = ""
    public var name: String = ""
    public var address: String = ""
    public var latitude: String = ""
    public var longitude: String = ""
    
    struct StaticInstance {
        static var instance: OwnerPlot?
    }
    
    class func sharedInstance() -> OwnerPlot {
        if(StaticInstance.instance == nil) {
            StaticInstance.instance = OwnerPlot()
        }
        return StaticInstance.instance!
    }
}

func requestPostPlot(ID: String, name: String, address: String, latitude: String, longitude: String) {
        // [URL 지정 및 파라미터 값 지정 실시]
        var urlComponents = URLComponents(string: "http://localhost:8888/parking_lot_registration?")
        let paramQuery_1 = URLQueryItem(name: "owner_id", value: ID)
        let paramQuery_2 = URLQueryItem(name: "name", value: name)
        let paramQuery_3 = URLQueryItem(name: "address", value: address)
        let paramQuery_4 = URLQueryItem(name: "latitude", value: latitude)
        let paramQuery_5 = URLQueryItem(name: "longitude", value: longitude)
        //let paramQuery_6 = URLQueryItem(name: "uploadFile", value: "image")
        
        urlComponents?.queryItems?.append(paramQuery_1)
        urlComponents?.queryItems?.append(paramQuery_2)
        urlComponents?.queryItems?.append(paramQuery_3)
    urlComponents?.queryItems?.append(paramQuery_4)
    urlComponents?.queryItems?.append(paramQuery_5)
    //urlComponents?.queryItems?.append(paramQuery_6)
    OwnerPlot.sharedInstance().owner = ID
    OwnerPlot.sharedInstance().name = name
    OwnerPlot.sharedInstance().address = address
    OwnerPlot.sharedInstance().latitude = latitude
    OwnerPlot.sharedInstance().longitude = longitude
    print(OwnerPlot.sharedInstance())
    OwnerPlotList.sharedInstance().pList.append(PlotForList(oid: ID, name: name, longitude: longitude, latitude: latitude, address: address))
    
    /*
        // [http 통신 타입 및 헤더 지정 실시]
    var requestURL = URLRequest(url: (urlComponents?.url)!)
            requestURL.httpMethod = "POST" // POST
            requestURL.addValue("application/json", forHTTPHeaderField: "Content-Type") // POST

        
        // [http 요쳥을 위한 URLSessionDataTask 생성]
        print("")
        print("====================================")
        print("[requestGet : http get 요청 실시 - 초기화]")
        print("url : ", requestURL)
        print("====================================")
        print("")

        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in

            // [error가 존재하면 종료]
            guard error == nil else {
                print("")
                print("====================================")
                print("[requestGet : http get 요청 실패]")
                print("fail : ", error?.localizedDescription ?? "")
                print("====================================")
                print("")
                return
            }

            // [status 코드 체크 실시]
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successsRange.contains(statusCode)
            else {
                print("")
                print("====================================")
                print("[requestGet : http get 요청 에러]")
                print("error : ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                print("msg : ", (response as? HTTPURLResponse)?.description ?? "")
                print("====================================")
                print("")
                return
            }

        }
        
    dataTask.resume()*/
}
