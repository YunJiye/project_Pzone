//
//  GetImage.swift
//  Pzone
//
//  Created by J on 2022/12/16.
//

import Foundation
import SwiftUI
import SwiftyJSON

class GetRes: ObservableObject {
    public var p = UIImage()
    
    struct StaticInstance {
        static var instance: GetRes?
    }
    
    class func sharedInstance() -> GetRes {
        if(StaticInstance.instance == nil) {
            StaticInstance.instance = GetRes()
        }
        return StaticInstance.instance!
    }
}

func requestGet() {

        // [URL 지정 및 파라미터 값 지정 실시]
        var urlComponents = URLComponents(string: "http://43.200.203.0:8080/get_result?")
        let paramQuery_1 = URLQueryItem(name: "ID", value: "1")
        urlComponents?.queryItems?.append(paramQuery_1) // 파라미터 지정
        
        
        // [http 통신 타입 및 헤더 지정 실시]
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        requestURL.httpMethod = "GET" // GET
        requestURL.addValue("application/x-www-form-urlencoded; charset=utf-8;", forHTTPHeaderField: "Content-Type") // GET

        
        // [http 요쳥을 위한 URLSessionDataTask 생성]
        print("")
        print("===============================")
        print("[A_Image >> requestGet :: http get 요청 실시]")
        print("url : ", requestURL)
        print("===============================")
        print("")
        let dataTask = URLSession.shared.dataTask(with: requestURL) { (data, response, error) in

            // [error가 존재하면 종료]
            guard error == nil else {
                print("")
                print("===============================")
                print("[A_Image >> requestGet :: http get 요청 실패]")
                print("fail :: ", error?.localizedDescription ?? "")
                print("===============================")
                print("")
                return
            }

            // [status 코드 체크 실시]
            let successsRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successsRange.contains(statusCode)
            else {
                print("")
                print("===============================")
                print("[A_Image >> requestGet :: http get 요청 에러]")
                print("error :: ", (response as? HTTPURLResponse)?.statusCode ?? 0)
                print("msg :: ", (response as? HTTPURLResponse)?.description ?? "")
                print("===============================")
                print("")
                return
            }

            // [response 데이터 획득]
            let resultCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            let resultLen = data! // 데이터 길이
            let mimeType = response?.mimeType // 응답 데이터 타입 확인
            
            
            // [응답 데이터 타입이 이미지 파일 인지 확인 실시]
            if ((mimeType?.lowercased().contains("image")) != nil) {
                print("")
                print("===============================")
                print("[A_Image >> requestGet :: http get 요청 성공]")
                print("resultCode :: ", resultCode)
                print("resultLen :: ", resultLen)
                print("mimeType :: ", mimeType ?? "")
                print("===============================")
                print("")
                
                
                DispatchQueue.main.async {
                    // [응답 데이터를 이미지로 받음]
                    let image = UIImage(data: data!)
                    
                    // [이미지 뷰에 표시 수행 실시]
                    GetRes.sharedInstance().p = image!
                }
            }
            else {
                print("")
                print("===============================")
                print("[A_Image >> requestGet :: http get 요청 에러]")
                print("resultCode :: ", resultCode)
                print("error :: ", "파일 형식이 이미지 파일이 아닙니다")
                print("mimeType :: ", mimeType ?? "")
                print("===============================")
                print("")
            }
        }

        // network 통신 실행
        dataTask.resume()
    }
