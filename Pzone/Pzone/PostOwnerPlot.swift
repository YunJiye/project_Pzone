//
//  PostOwnerPlot.swift
//  Pzone
//
//  Created by J on 2022/12/11.
//

/*
 
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
             
             AF.upload(multipartFormData: { (multipart) in
                 for (key, value) in body {
                     multipart.append("\(value)".data(using: .utf8, allowLossyConversion: false)!, withName: "\(key)", mimeType: "text/plain")
                 }
                 if let imageData = photo.jpegData(compressionQuality: 1) {
                     multipart.append(imageData, withName: "uploadFile", fileName: "\(owner_id)_photo.jpg", mimeType: "image/jpeg")
                 }
             }, to: "http://localhost:8888/parking_lot_registration"    //전달할 url
             ,method: .post        //전달 방식
             ,headers: header).responseJSON(completionHandler: { (response) in    //헤더와 응답 처리
                 print(response)
                 
                 if let err = response.error{    //응답 에러
                     print(err)
                     return
                 }
                 print("success")        //응답 성공
                 
                 let json = response.data
                 
                 if (json != nil){
                     print(json)
                 }
             })
             
         }
     }

 
 
 
 
 */
