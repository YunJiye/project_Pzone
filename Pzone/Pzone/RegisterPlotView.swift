//
//  RegisterPlotView.swift
//  Pzone
//
//  Created by J on 2022/12/02.
//

import Foundation
import SwiftUI

struct RegisterPlotView: View {
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var longitude: String = ""
    @State private var latitude: String = ""
    @State private var isLogin: Bool = false
    @State private var isOwner: Bool = false
    @State private var showingAlert: Bool = false
    private var correctUserId: String = "kim"
    private var correctPassword: String = "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"
    
    var body: some View {
        NavigationView{
            VStack{
                Text("주차장을 등록해주세요")
                    .font(.title)
                    .padding(.bottom, 40)
                Spacer(minLength: 10)
                HStack {
                    Spacer()
                    Text("장소명")
                    Spacer()
                    TextField("입력", text: $name)
                        .autocapitalization(.none)
                        .frame(width: 240, height: 30)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("주소")
                    Spacer()
                    TextField("입력", text: $address)
                        .autocapitalization(.none)
                        .frame(width: 240, height: 30)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("경도")
                    Spacer()
                    TextField("입력", text: $longitude)
                        .autocapitalization(.none)
                        .frame(width: 240, height: 30)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("위도")
                    Spacer()
                    TextField("입력", text: $latitude)
                        .autocapitalization(.none)
                        .frame(width: 240, height: 30)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text("주차장 도면")
                    Spacer()
                    TextField("입력", text: $name)
                        .autocapitalization(.none)
                        .frame(width: 240, height: 30)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    Spacer()
                }
                
                
                NavigationLink(destination: CustomTabView(), isActive: $isLogin){
                    Button(action: {
                        //login(userId, password)
                    }
                    ){
                        Text("등록")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 60)
                            .background(Color("MainColor"))
                            .cornerRadius(30)
                    }
                }
                
                Spacer(minLength: 250)
            
        }.padding()
            .padding(.top, 120)
            .ignoresSafeArea()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("실패"), message: Text("등록이 완료되었습니다."), dismissButton: .default(Text("닫기")))
            }
    }
}

func login(_ userId: String, _ password: String){
    if(true){
        isLogin = true
    } else {
        showingAlert = true
    }
}

}

struct RegisterPlotView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPlotView()
    }
}
