//
//  PostOwner.swift
//  Pzone
//
//  Created by J on 2022/12/10.
//

import Foundation
import SwiftUI
import SwiftyJSON


func requestPostOwner(ID: String, PW: String, token: String) {
        // [URL 지정 및 파라미터 값 지정 실시]
        var urlComponents = URLComponents(string: "http://43.200.203.0:8080/set_owner?")
        let paramQuery_1 = URLQueryItem(name: "ID", value: ID)
        let paramQuery_2 = URLQueryItem(name: "PW", value: PW)
    let paramQuery_3 = URLQueryItem(name: "token", value: token)

        urlComponents?.queryItems?.append(paramQuery_1)
        urlComponents?.queryItems?.append(paramQuery_2)
    urlComponents?.queryItems?.append(paramQuery_3)
        
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
        
    dataTask.resume()
}
