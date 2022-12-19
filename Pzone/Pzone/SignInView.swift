//
//  SignUpView.swift
//  Pzone
//
//  Created by J on 2022/11/10.
//

import SwiftUI
import CryptoKit

struct SignInView: View {
    @State private var userId: String = ""
    @State private var password: String = ""
    @State private var isLogin: Bool = false
    @State private var isNew: Bool = false
    @State private var isOwner: Bool = false
    @State private var showingAlert: Bool = false
    private var correctUserId: String = "admin"
    private var correctPassword: String = "5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8"
    
    var body: some View {
        NavigationView{
            VStack{
                Text("로그인")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .fontWeight(.medium)
                    .padding(.top, 50)
                    .padding(.bottom, 40)
            
                Spacer(minLength: 40)
                VStack {
                    HStack {
                        Spacer(minLength: 30)
                        HStack{
                            Button{
                                isOwner = false
                            } label: {
                                Image(systemName: "circle")
                                    .background(self.isOwner == true ? Color(.clear)  : Color(.systemBlue))
                                        .cornerRadius(10)
                            }
                            Text("일반회원")
                            Spacer()
                        }
                        HStack{
                            Button{
                                isOwner = true
                            } label: {
                                Image(systemName: "circle")
                                    .background(self.isOwner != true ? Color(.clear)  : Color(.systemBlue))
                                        .cornerRadius(10)
                            }
                            Text("사업자")
                            Spacer()
                        }
                    }
                    TextField("아이디", text: $userId)
                        .autocapitalization(.none)
                        .frame(width: 300, height: 30)
                        .font(.headline)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(15)
                    SecureField("비밀번호", text: $password){
                        login(userId, password)
                    }
                    .frame(width: 300, height: 30)
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(15)
                    Spacer(minLength: 30)
                    VStack {
                        if (isOwner == true) {
                            NavigationLink(destination: OwnerPlotListView(), isActive: $isLogin){
                                Button(action: {
                                    login(userId, password)
                                }
                                ){
                                    Text("로그인")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .frame(width: 200, height: 60)
                                        .background(Color("MainColor"))
                                        .cornerRadius(30)
                                }
                            }} else {
                                NavigationLink(destination: CustomTabView(), isActive: $isLogin){
                                    Button(action: {
                                        login(userId, password)
                                    }
                                    ){
                                        Text("로그인")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                            .padding()
                                            .frame(width: 200, height: 60)
                                            .background(Color("MainColor"))
                                            .cornerRadius(30)
                                    }
                                }
                            }
                        
                        NavigationLink(destination: SignUpView(), isActive: $isNew){
                            Button(action: {
                                isNew = true
                            }
                            ){
                                Text("회원가입")
                                    .font(.headline)
                                    .padding(.top, 10)
                                    .foregroundColor(Color("MainColor"))
                            }
                        }
                    }
                }
                Spacer(minLength: 300)
            }.padding()
                .padding(.top, 120)
                .ignoresSafeArea()
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text("실패"), message: Text("아이디 또는 패스워드가 잘못되었습니다."), dismissButton: .default(Text("닫기")))
                }
        }.navigationBarBackButtonHidden()
    }
    
    func login(_ userId: String, _ password: String){
        if(isOwner != true) {
            requestGetUserToken(ID: userId, PW: password)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let correctToken = GetUserToken.sharedInstance().token
                
                if(correctToken == toSHA256(password)){
                    self.password = ""
                    UserDefaults.standard.set(userId, forKey: "id")
                    UserDefaults.standard.set(password, forKey: "password")
                    isLogin = true
                } else {
                    showingAlert = true
                }
            }
        } else {
            requestGetOwnerToken(ID: userId, PW: password)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                let correctToken = GetUserToken.sharedInstance().token
                
                if(correctToken == toSHA256(password)){
                    self.password = ""
                    UserDefaults.standard.set(userId, forKey: "id")
                    UserDefaults.standard.set(password, forKey: "password")
                    isLogin = true
                } else {
                    showingAlert = true
                }
            }
        }
    }
    
    func toSHA256(_ password: String) -> String {
        let data = password.data(using: .utf8)
        let sha256 = SHA256.hash(data: data!)
        let shaData = sha256.compactMap{String(format: "%02x", $0)}.joined()
        return shaData
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}


