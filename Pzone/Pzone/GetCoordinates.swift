//
//  GetCoordinates.swift
//  Pzone
//
//  Created by J on 2022/12/03.
//

import Foundation
import SwiftUI
import SwiftyJSON

class GetCoordinates: ObservableObject {
    public var latitude: String = ""
    public var longitude: String = ""
    public var ss: String = "test"
    
    struct StaticInstance {
        static var instance: GetCoordinates?
    }
    
    class func sharedInstance() -> GetCoordinates {
        if(StaticInstance.instance == nil) {
            StaticInstance.instance = GetCoordinates()
        }
        return StaticInstance.instance!
    }
}

func requestGetCoordinates(inputText: String) {
        // [URL 지정 및 파라미터 값 지정 실시]
        var urlComponents = URLComponents(string: "https://naveropenapi.apigw.ntruss.com/map-geocode/v2/geocode?")
        
    //let urlC = URLComponents(string: queryStr)
        let paramQuery_1 = URLQueryItem(name: "query", value: inputText)
        
        //let paramQuery_2 = URLQueryItem(name: "name", value: "1")
        urlComponents?.queryItems?.append(paramQuery_1) // 파라미터 지정
        //urlComponents?.queryItems?.append(paramQuery_2) // 파라미터 지정
        
        // [http 통신 타입 및 헤더 지정 실시]
    var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "GET" // GET
        requestURL.addValue("application/x-www-form-urlencoded; charset=utf-8;", forHTTPHeaderField: "Content-Type") // GET
        requestURL.addValue("kyoivelxk9", forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        requestURL.addValue("F6fRnz1OwCV7RQnPcUESNoKXFWYEnIl0qlzuZosJ", forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
            
           
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
            
            for (index, subJson) : (String, JSON) in responseJson {
                
                guard let test = subJson[0].dictionary
                        
                else {
                    continue
                }
                //print(test)
                let id = test["x"]?.string
                //print("_____________")
                var a = ""
                var b = ""
                for (index, subJson1) : (String, JSON) in test {

                    if (index == "x") {
                        let id = test["x"]?.string
                        a = id!
                    }
                    else if (index == "y") {
                        let id = test["y"]?.string
                        b = id!
                    }
                    else { continue }
                }
                //print("longitude: \(a) / latitude: \(b)")
                GetCoordinates.sharedInstance().longitude = a
                GetCoordinates.sharedInstance().latitude = b
                print(GetCoordinates.sharedInstance().longitude, GetCoordinates.sharedInstance().latitude)

            }
        }
        
    dataTask.resume()
}

