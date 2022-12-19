//
//  SignUpTypeView.swift
//  Pzone
//
//  Created by J on 2022/11/28.
//

import Foundation
import SwiftUI
import CryptoKit

struct SignUpOwnerView: View {
    @State private var userId: String = ""
    @State private var password: String = ""
    @State private var isCorrect: Bool = false
    @State private var isLogin: Bool = false
    @State private var isOwner: Bool = false
    @State private var showingAlert: Bool = false
    private var correctUserId: String = "admin"
    private var correctPassword: String = "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"
    
    var body: some View {
        NavigationView{
            VStack{
                Text("사업자 등록")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                Spacer()
                
                VStack {
                    HStack {
                        Spacer(minLength: 10)
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding()
                        
                        TextField("아이디를 입력해주세요", text: $userId)
                            .autocapitalization(.none)
                            .frame(width: 280, height: 30)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                        Spacer(minLength: 30)
                    }
                    HStack {
                        Spacer(minLength: 10)
                        Image(systemName: "lock")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .padding()

                        TextField("비밀번호를 입력해주세요", text: $password){
                            signUp(userId, password)
                        }
                        .frame(width: 280, height: 30)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                        Spacer(minLength: 30)
                    }
                }
                NavigationLink(destination: SignInView(), isActive: $isCorrect){
                    Button(action: {
                        signUp(userId, password)
                    }
                    ){
                        Text("회원가입")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 60)
                            .background(Color("MainColor"))
                            .cornerRadius(30)
                    }.padding(.top, 20)
                }
                Spacer(minLength: 300)
            }.padding()
                .padding(.top, 130)
                .ignoresSafeArea()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("실패"), message: Text("아이디 또는 패스워드가 잘못되었습니다."), dismissButton: .default(Text("닫기")))
                }
        }.navigationBarBackButtonHidden()
    }
    
    
    func signUp(_ userId: String, _ password: String){
        let token = toSHA256(password)
        requestPostOwner(ID: userId, PW: password, token: token)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            isCorrect = true
            
        }
    }
    
    func toSHA256(_ password: String) -> String {
        let data = password.data(using: .utf8)
        let sha256 = SHA256.hash(data: data!)
        let shaData = sha256.compactMap{String(format: "%02x", $0)}.joined()
        return shaData
    }
}

struct SignUpOwnerView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpOwnerView()
    }
}
