//
//  DetailView.swift
//  Pzone
//
//  Created by J on 2022/12/05.
//

import Foundation
import SwiftUI

struct DetailView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State var isDetail:Bool = false
    
    var body: some View {
        NavigationView{
            VStack{
                Spacer(minLength: 10)
                HStack {
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                    Spacer(minLength: 30)
                }.padding(.bottom, 40)
                Spacer(minLength: 20)
                Text(GetPlot.sharedInstance().p.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 30)
                Text(GetPlot.sharedInstance().p.address)
                    .font(.headline)
                    .padding(.bottom, 20)
                HStack {
                    Text(GetPlot.sharedInstance().p.latitude)
                    Text(GetPlot.sharedInstance().p.longitude)
                }.padding(.bottom, 50)
                HStack {
                    Image("CarIcon")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Image("CarIcon")
                        .resizable()
                        .frame(width: 100, height: 100)
                    Image("CarIcon")
                        .resizable()
                        .frame(width: 100, height: 100)
                    //.overlay(Rectangle().stroke()).foregroundColor(.gray)
                }
                Text("10자리 남았습니다")
                    .font(.title2)
                
                NavigationLink(destination: DriveView(), isActive: $isDetail){
                    Button(action: {
                        print("버튼 터치")
                        requestGet()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                            isDetail = true
                        }
                    }) {
                        Text("주차하러 가기")
                            .padding()
                            .frame(width: 180, height: 45)
                            .background(Color("MainColor"))
                            .cornerRadius(30)
                            .font(.body)
                            .foregroundColor(.white)
                    }
                }
                
                Spacer(minLength: 200)
            }
            .navigationBarHidden(true)
            .padding(.horizontal, 40)
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView()
    }
}
