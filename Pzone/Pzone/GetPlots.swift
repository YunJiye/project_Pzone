//
//  GetPlots.swift
//  Pzone
//
//  Created by J on 2022/12/02.
//

import Foundation
import SwiftUI
import SwiftyJSON

class GetPlot: ObservableObject {
    public var p = Plot()
    
    struct StaticInstance {
        static var instance: GetPlot?
    }
    
    class func sharedInstance() -> GetPlot {
        if(StaticInstance.instance == nil) {
            StaticInstance.instance = GetPlot()
        }
        return StaticInstance.instance!
    }
}

class GetPlots: ObservableObject {
    public var p_list: [Plot] = []
    public var selected_p: String = ""
    
    struct StaticInstance {
        static var instance: GetPlots?
    }
    
    class func sharedInstance() -> GetPlots {
        if(StaticInstance.instance == nil) {
            StaticInstance.instance = GetPlots()
        }
        return StaticInstance.instance!
    }
}

func requestGetAllPlotss() {
        // [URL 지정 및 파라미터 값 지정 실시]
        var urlComponents = URLComponents(string: "http://43.200.203.0:8080/get_all_parking_lot_info")

        
        // [http 통신 타입 및 헤더 지정 실시]
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "GET" // GET
        requestURL.addValue("application/x-www-form-urlencoded; charset=utf-8;", forHTTPHeaderField: "Content-Type") // GET

        
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

            let responseJson = JSON(data!)
            
            for (index, subJson) : (String, JSON) in responseJson {
                guard let id = subJson["id"].int,
                    let name = subJson["name"].string,
                    let longitude = subJson["longitude"].float,
                    let latitude = subJson["latitude"].float,
                    let address = subJson["address"].string else {
                    continue
                }
                print(id, name, longitude, latitude, address)
                GetPlots.sharedInstance().p_list.append(Plot(oid: id, name: name, longitude: String(describing: longitude), latitude: String(describing: latitude), address: address))
            }
        }
        
    dataTask.resume()
}

