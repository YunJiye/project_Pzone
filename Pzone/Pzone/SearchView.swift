//
//  SearchView.swift
//  Pzone
//
//  Created by J on 2022/11/03.
//

import SwiftUI
import NMapsMap
import CoreLocation

struct SearchView: View {
    @State var text : String = ""
    @State private var correctAddr: Bool = false
    
    @State private var lat: Double = 0
    @State private var lon: Double = 0
    
    var body: some View {
        NavigationView{
            ZStack {
                Color(.systemGray6).ignoresSafeArea()
                
                VStack {
                    Spacer(minLength: 200)
                    VStack {
                        Text("원하는 주소를 입력해주세요")
                        searchBar(text: self.$text)
                        Spacer(minLength: 10)
                        NavigationLink(destination: SearchMapView(startlat: $lat, startlon: $lon), isActive: $correctAddr){
                            Button(action: {
                                saveButton()
                            }, label: {
                                Text("Go")
                                    .padding()
                                    .frame(width: 65, height: 45)
                                    .background(Color("MainColor"))
                                    .cornerRadius(30)
                                    .font(.body)
                                    .foregroundColor(.white)
                            })
                        }
                    }.frame(height: 100)
                    Spacer(minLength: 280)
                }
            }
        }
    }
    
    func saveButton() {
        requestGetCoordinates(inputText: self.text)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            lat = NumberFormatter().number(from: GetCoordinates.sharedInstance().latitude)?.doubleValue ?? 37.551114
            
            lon = NumberFormatter().number(from: GetCoordinates.sharedInstance().longitude)?.doubleValue ?? 126.940938
            correctAddr = true
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

struct searchBar: View {
    @Binding var text : String
    @State var editText : Bool = false
    
    var body: some View {
        HStack{
            TextField("예) 서울시 마포구" , text : self.$text)
                .frame(width: 300, height: 35, alignment: .center)
                .padding(15)
                .padding(.horizontal,15)
            //.background(Color(.systemGray6))
                .background(Color.white)
                .cornerRadius(30)
                
                .overlay(
                    HStack{
                        Spacer()
                        if self.editText{
                            //x버튼이미지를 클릭하게되면 입력되어있던값들을 취소하고
                            //키입력 이벤트를 종료해야한다.
                            Button(action : {
                                self.editText = false
                                self.text = ""
                                //키보드에서 입력을 끝내게하는 코드
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }){
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(Color(.black))
                                    .padding()
                            }
                        }else{
                            //magnifyingglass 를 사용
                            //색상은 자유롭게 변경가능
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(.black))
                                .padding()
                        }
                        
                    }
                ).onTapGesture {
                    self.editText = true
                }
        }
        
        
    }
}
