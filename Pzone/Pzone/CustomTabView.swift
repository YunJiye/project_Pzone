//
//  TabView.swift
//  Pzone
//
//  Created by J on 2022/11/09.
//

import SwiftUI

import SwiftUI

struct CustomTabView: View {
    @State private var selectedIndex = 0
    @Namespace var namespace
    
    let tabBarNames = ["내 근처 주차장 찾기", "목적지 근처 주차장 찾기      "]
    
    var body: some View {
        VStack(spacing : 0) {
            GeometryReader{ g in
                HStack{
                    ForEach(tabBarNames.indices, id: \.self) { index in
                        VStack {
                            Text(tabBarNames[index])
                                .frame(height: 50)
                            if selectedIndex == index {
                                Color("MainColor")
                                    .frame(width: UIScreen.main.bounds.width/2, height: 2)
                                    .matchedGeometryEffect(id: "underline", in: namespace.self)
                            } else {
                                Color.clear.frame(height: 2)
                            }
                        }
                        .gesture(
                            TapGesture()
                                .onEnded { _ in
                                    selectedIndex = index
                                })
                    }.frame(width: g.size.width / 2, height: 60)
                }
            }.frame(maxHeight: 60)
            
            ZStack {
                switch selectedIndex {
                case 0:
                    MapView()
                default:
                    SearchView()
                }
            }
        }.navigationBarHidden(true)

    }
}

struct TabBarItem: View {
    @State var selectedIndex: Int
    let namespace: Namespace.ID
    
    var title: String
    var tab: Int
    
    var body: some View {
        VStack {
            Text(title)
                .frame(height: 50)
            if selectedIndex == tab {
                Color("MainColor")
                    .frame(width: UIScreen.main.bounds.width/2, height: 2)
                    .matchedGeometryEffect(id: "underline", in: namespace.self)
            } else {
                Color.clear.frame(height: 2)
            }
        }
        .frame(height: 60)
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView()
    }
}
