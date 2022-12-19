//
//  Alamo.swift
//  Pzone
//
//  Created by J on 2022/12/16.
//

import Foundation
import Alamofire

struct PlotPost {
    static let data = PlotPost()
    
    let header: HTTPHeaders = [
        "Content-type": "multipart/form-data"
    ]
    
    func uploadNewPlot(owner_id: String, name: String, address: String, latitude: Double, longitude: Double, _ photo : UIImage){
        
        let body : Parameters = [
            "owner_id" : owner_id,
            "name" : name,
            "address" : address,
            "latitude" : latitude,
            "longitude" : longitude
        ]
        let url = "http://43.200.203.0:8080/parking_lot_registration"
        
        let call = AF.upload(multipartFormData: { multipartFormData in
            //for (key, value) in body {
            //multipartFormData.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)", mimeType: "text/plain")
            //}
            multipartFormData.append(Data(owner_id.utf8),
                                     withName: "owner_id")
            multipartFormData.append(Data(name.utf8),
                                     withName: "name")
            multipartFormData.append(Data(address.utf8),
                                     withName: "address")
            multipartFormData.append(Data(String(latitude).utf8),
                                     withName: "latitude")
            multipartFormData.append(Data(String(longitude).utf8),
                                     withName: "longitude")
            if let imageData = photo.jpegData(compressionQuality: 1) {
                multipartFormData.append(imageData, withName: "uploadFile", fileName: "\(owner_id)_photo.jpg", mimeType: "image/jpeg")
            }
        }, to: url
                             ,method: .post
                             ,headers: header).responseJSON(completionHandler: { (response) in
            guard let statusCode = response.response?.statusCode else { return }
            
            switch statusCode {
                
            case 200:
                print("성공")
            default:
                if let responseJSON = try! response.result.get() as? [String : String] {
                    
                    if let error = responseJSON["error"] {
                            print(error)
                    }
                }
            }
        })
        
    }
}
