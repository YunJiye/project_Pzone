//
//  ParkingLotList.swift
//  Pzone
//
//  Created by J on 2022/11/11.
//

import Foundation
import SwiftUI

struct OwnerPlotListView: View {
    @State var addMore = false
    @State private var showingAlert: Bool = false
    @State private var isHome: Bool = false
    
    @State var data = OwnerPlotList.sharedInstance()
    //@State var data = OwnerPlot.sharedInstance()
    //let data = GetPlots.sharedInstance().p_list
    @State var refresh = false
    
    var body: some View {

        VStack {
            
            HStack {
                Spacer(minLength: 10)
                NavigationLink(destination: SignInView(), isActive: $isHome){
                    Button(action: {
                        showingAlert.toggle()
                        
                    }, label: {
                        Image(systemName: "return")
                            .resizable()
                            .frame(width: 25, height: 25)
                    })
                }
                let userId = UserDefaults.standard.string(forKey: "id")
                
                Spacer(minLength: 110)
                Text(userId! + "님의 목록")
                Spacer(minLength: 100)
                Button(action: {
                    addMore = true
                    print(data)
                }, label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 25, height: 25)
                })
                Spacer(minLength: 10)
            }.frame(height: 80)
            List {
                ForEach(0..<data.pList.count, id: \.self) { i in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(data.pList[i].name)
                                .frame(height: 20)
                                .font(.headline)
                            HStack {
                                Text(data.pList[i].address)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            HStack {
                                Text(data.pList[i].longitude)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                Text(data.pList[i].latitude)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                        }
                        Spacer()
                    }
                }
                
            }.sheet(isPresented: $addMore) {
                AddPlotView(refresh: $refresh)
            }
            NavigationLink(destination: OwnerPlotListView(), isActive: $refresh){
                Button(action: {}){
                }
            }
        }.navigationBarBackButtonHidden()
            .alert(isPresented: $showingAlert) {
                let secondButton = Alert.Button.cancel(Text("확인")) {
                    print("HI")
                    isHome = true
                    
                }
                return Alert(title: Text("홈으로 돌아가기"), message: Text("계정이 로그아웃됩니다. 계속하시겠습니까?"), primaryButton: .destructive(Text("취소"), action: {
                }), secondaryButton: secondButton)
            }
    }
    
}

struct PlotRow: View {
    let plot = Plot()
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(plot.name)
                    .frame(height: 20)
                    .font(.headline)
                HStack {
                    Text(plot.longitude)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }
                Text("HI")
            }
            Spacer()
            
            Button(">>") {
                print(plot.name)
            }
        }
    }
}

struct OwnerPlotListView_Previews: PreviewProvider {
    static var previews: some View {
        OwnerPlotListView()
    }
}
