//
//  Lazzaro.swift
//  SideMenuUi
//
//  Created by Sabir Myrzaev on 12.05.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import SwiftUI

struct Lazzaro: View {
    var body: some View {
        LazzaroDetail()
    }
}
struct LazzaroDetail: View{
    @State var show = false
    @State var isCart = false
    @State private var age = 1
         @Environment(\.presentationMode) var presentationMode
    var body: some View{
        
        VStack{
            ScrollView{
                VStack(spacing: 0){
                    ZStack {
                        
                        HStack{
                            
                                                 Button(action: {
                                           self.presentationMode.wrappedValue.dismiss()
                                       }) {
                                           Image(systemName: "lessthan")
                                               .resizable()
                                               .frame(width: 15, height: 15)
                                               .foregroundColor(.white)
                                               .padding(.leading, 30)
                                   }
                            
                            Spacer()
                            
                            Button(action: {
                                //code
                            }) {
                                Image(systemName: "cart")
                                    .resizable()
                                    .frame(width: 25, height: 20)
                                    .foregroundColor(.white)
                                    .padding(.trailing)
                            }
                        }
                        
                        Image("logoRosKeramik")
                            .resizable()
                            .frame(width: 240, height: 60)
                            .font(.title)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(red: 43.0/255.0, green: 43.0/255.0, blue: 43.0/255.0))
                    
                    Image("123").resizable().frame(width: 450, height: 60)
                }
                
                VStack(alignment: .leading, spacing: 3){
                    Text("Lazzaro").fontWeight(.bold).padding(.bottom,20).padding(.top, 10)
                    Image("lazzaro").resizable().frame(width: 350, height: 400)
                    HStack{
                        Text("Цена:")
                        Spacer()
                        Text("847 сомов").fontWeight(.bold)
                    }
                    HStack{
                        Text("Добавить в корзину:").foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            //code
                        }) {
                            Button(action: {
                                self.isCart.toggle()
                            }) {
                            Image(systemName: "cart.badge.plus")
                                .resizable()
                                .frame(width: 45, height: 30)
                                .foregroundColor(.yellow).sheet(isPresented: self.$isCart) {
                                                VStack{
                                                    MainDetail()
                                                    Spacer()
                                                  Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                    Spacer()
                                                    ImageCarouselView(numberOfImages: 2) {
                                                        Image("lazzaro")
                                                        .renderingMode(.original)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 420, height: 250)
                                                        .clipped().padding(.bottom, 20)
                                                        Image("lazzaro")
                                                        .renderingMode(.original)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: 420, height: 250)
                                                        .clipped().padding(.bottom, 20)
                                    
                                                    }.padding(.bottom, 20)
                                                    Spacer()
                                                ItemDetail()
                                                }
                                        }
                                }
                            
                        }
                    }
                }.padding(.horizontal, 50)
                
                GeometryReader{ geo in
                    VStack(alignment: .leading,spacing: 10) {
                        HStack{
                            Text("Производитель:")
                            Spacer()
                            Text("Russia")
                        }
                        HStack{
                            Text("Размер:")
                            Spacer()
                            Text("Universal")
                        }
                        HStack{
                            Text("Поверхность:")
                            Spacer()
                            Text("Глянцевая")
                        }
                        HStack{
                            Text("Стиль:")
                            Spacer()
                            Text("Керамика")
                        }
                        Text("---------------------------------------------")
                        HStack{
                            Text("Поделиться:").font(.system(size: 14))
                            Spacer()
                            Image(systemName: "checkmark.circle").foregroundColor(Color.green).frame(width: 12, height: 12)
                            Text("Коллекция доступна для заказа").font(.system(size: 12)).fontWeight(.bold)
                        }.padding(.bottom, 100)
                    }
                    
                }.background(Color.white).padding(.horizontal, 50).padding(.top, 120)
                
            }
            
        }
    }
}

