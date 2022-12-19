//
//  AddPlotView.swift
//  Pzone
//
//  Created by J on 2022/12/10.
//

import Foundation
import SwiftUI

struct AddPlotView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State private var name: String = ""
    @State private var address: String = ""
    @State private var latitude: String = ""
    @State private var longitude: String = ""
    @State private var showingImagePicker = false
    @State var pickedImage: Image?
    @State var uiPickedImage: UIImage?
    
    @State private var isCorrect: Bool = false
    @State private var showingAlert: Bool = false

    @Binding var refresh: Bool
    
    var body: some View {
        NavigationView{
            VStack{
                HStack {
                    Spacer(minLength: 300)
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancel")
                    }
                    Spacer(minLength: 20)
                }.padding(.bottom, 40)
                Text("주차장 등록")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 50)
                    .padding(.bottom, 50)
                Spacer()
                
                VStack {
                    HStack {
                        VStack {
                            TextField("주차장 이름", text: $name)
                                .autocapitalization(.none)
                                .frame(width: 280, height: 30)
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.trailing, 16)
                                .cornerRadius(15)
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(Color(.systemGray5))
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                            Spacer(minLength: 30)
                        }
                    }
                    VStack {
                        TextField("주소", text: $address)
                            .autocapitalization(.none)
                            .frame(width: 280, height: 30)
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding(.trailing, 16)
                            .cornerRadius(15)
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(Color(.systemGray5))
                            .padding(.leading, 16)
                            .padding(.trailing, 16)
                        Spacer(minLength: 30)
                    }
                    HStack(spacing: 0) {
                        VStack {
                            TextField("위도", text: $latitude)
                                .autocapitalization(.none)
                                .frame(width: 90, height: 30)
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.trailing, 16)
                                .cornerRadius(15)
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(Color(.systemGray5))
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                            Spacer(minLength: 30)
                        }
                        VStack {
                            TextField("경도", text: $longitude)
                                .autocapitalization(.none)
                                .frame(width: 90, height: 30)
                                .font(.headline)
                                .foregroundColor(.black)
                                .padding(.trailing, 16)
                                .cornerRadius(15)
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(Color(.systemGray5))
                                .padding(.leading, 16)
                                .padding(.trailing, 16)
                            Spacer(minLength: 30)
                        }
                    }
                    VStack {
                        Button(action: {
                            self.showingImagePicker.toggle()
                        }, label: {
                            Text("도면 이미지 등록")
                        }).sheet(isPresented: $showingImagePicker) {
                            ImagePicker(sourceType: .photoLibrary) { (image) in
                                
                                self.pickedImage = Image(uiImage: image)
                                self.uiPickedImage = image
                                print(image)
                            }
                        }
                        pickedImage?.resizable()
                            .frame(height:100)
                    }
                }

                NavigationLink(destination: OwnerPlotListView(), isActive: $isCorrect){
                    Button(action: {
                        let userId = UserDefaults.standard.string(forKey: "id")
                    
                        let lat = NumberFormatter().number(from: latitude)?.doubleValue
                        let lon = NumberFormatter().number(from: longitude)?.doubleValue
                        
                        PlotPost.data.uploadNewPlot(owner_id: userId!, name: name, address: address, latitude: lat!, longitude: lon!, uiPickedImage!)
                        requestPostPlot(ID: userId!, name: name, address: address, latitude: latitude, longitude: longitude)
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {

                            isCorrect = true
                            refresh = true
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    ){
                        Text("완료")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 200, height: 60)
                            .background(Color("MainColor"))
                            .cornerRadius(30)
                    }.padding(.top, 20)
                }
                Spacer(minLength: 250)
            }.padding()
                .padding(.top, 130)
                .ignoresSafeArea()
        }
    }
    
}
