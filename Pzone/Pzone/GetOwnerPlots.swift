//
//  GetOwnerPlots.swift
//  Pzone
//
//  Created by J on 2022/12/10.
//

import Foundation
import SwiftUI
import SwiftyJSON

class GetOwnerPlots: ObservableObject {
    public var p_list: [Plot] = []
    public var selected_p: String = ""
    
    struct StaticInstance {
        static var instance: GetOwnerPlots?
    }
    
    class func sharedInstance() -> GetOwnerPlots {
        if(StaticInstance.instance == nil) {
            StaticInstance.instance = GetOwnerPlots()
        }
        return StaticInstance.instance!
    }
}

func requestGetOwnerPlots(owner: String) {
        // [URL 지정 및 파라미터 값 지정 실시]
        var urlComponents = URLComponents(string: "http://43.200.203.0:8080/get_parking_list_by_owner_id")
        let paramQuery_1 = URLQueryItem(name: "owner", value: owner)

        urlComponents?.queryItems?.append(paramQuery_1) // 파라미터 지정

        
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
            print(responseJson)
            /*
            for (index, subJson) : (String, JSON) in responseJson {
                guard let id = subJson["id"].int,
                    let name = subJson["name"].string,
                    let longitude = subJson["longitude"].string,
                    let latitude = subJson["latitude"].string else {
                    continue
                }
                //GetOwnerPlots.sharedInstance().p_list.append(Plot(oid: id, name: name, longitude: longitude, latitude: latitude))
            }*/
        }
        
    dataTask.resume()
}

