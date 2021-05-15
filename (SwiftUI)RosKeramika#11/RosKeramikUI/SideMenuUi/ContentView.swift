//
//  ContentView.swift
//  SideMenuUi
//
//  Created by Sabir Myrzaev on 10.05.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var index = "Основная информация"
    @State var show = false
    
    var body: some View {
        
        ZStack {
            
            (self.show ? Color.black.opacity(0.05) : Color.clear).edgesIgnoringSafeArea(.all)
            
            ZStack(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 25){
                    
                    
                    Image("logoRosKeramik")
                        .resizable()
                        .frame(width: 400, height: 100)
                        .background(Color(red: 43.0/255.0, green: 43.0/255.0, blue: 43.0/255.0))
                    
                    Image("aygrand")
                        .resizable()
                        .frame(width: 210, height: 60)
                    
                    ForEach(data, id: \.self){i in
                        
                        Button(action: {
                            self.index = i
                            
                            withAnimation(.spring()) {
                                self.show.toggle()
                            }
                        }) {
                            
                            HStack{
                                
                                Capsule()
                                    .fill(self.index == i ? Color.yellow : Color.clear)
                                    .frame(width: 5, height: 30)
                                
                                Text(i).padding(.leading)
                                    .foregroundColor(.black)
                            }
                        }
                        
                    }
                    
                    Spacer()
                }.padding(.leading)
                    .padding(.top)
                    .scaleEffect(self.show ? 1 : 0)
                
                ZStack(alignment: .topTrailing){
                    
                    MainView(show: self.$show, index: self.$index)
                        .scaleEffect(self.show ? 0.8 : 1)
                        .offset(x: self.show ? 200 : 0, y: self.show ? 50 : 0)
                        .disabled(self.show ? true : false)
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            self.show.toggle()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .foregroundColor(.white)
                    }.padding(.top, 25)
                        .padding(.trailing, 7)
                        .opacity(self.show ? 1 : 0)
                }
                
                
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MainView: View {
    @State var cart = false
    @Binding var show: Bool
    @Binding var index: String
    @State var showFavoriteOnly = false
        @Environment(\.presentationMode) var presentationMode
    
    
    var body: some View {
        
        VStack(spacing: 0) {
            
            ZStack {
                
                HStack{
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            self.show.toggle()
                        }
                        
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .resizable()
                            .frame(width: 30, height: 20)
                            .foregroundColor(.white)
                            .padding(.leading)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.spring()) {
                            self.cart.toggle()
                        }
                    }) {
                        Image(systemName: "cart")
                            .resizable()
                            .frame(width: 25, height: 20)
                            .foregroundColor(.white)
                            .padding(.trailing)
                    }.sheet(isPresented: self.$cart) {
                        if !self.showFavoriteOnly {
                            VStack(spacing: 0){
                                               ZStack {
                                                   
                                                   HStack{
                                                       
                                                       Button(action: {
                                                           withAnimation(.spring()) {
                                                               self.show.toggle()
                                                        self.presentationMode.wrappedValue.dismiss()
                                                           }
                                                           
                                                       }) {
                                                           Image(systemName: "arrow.up.circle")
                                                               .resizable()
                                                               .frame(width: 30, height: 30)
                                                               .foregroundColor(.white)
                                                               .padding(.leading)
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
                                               
            
                                           }
                            Spacer()
                            Image(systemName: "cart").resizable().frame(width: 100, height: 80).foregroundColor(.yellow)
                            Spacer()
                            Text("Ваша корзина пуста!")
                        }
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
            
            ZStack{
                
                Home().opacity(self.index == "Основная информация" ? 1 : 0)
                KeramikTile().opacity(self.index == "Керамическая плитка" ? 1 : 0)
                Keramogranit().opacity(self.index == "Керамогранит" ? 1 : 0)
                WarmFloor().opacity(self.index == "Теплый пол" ? 1 : 0)
                AboutUs().opacity(self.index == "О нас" ? 1 : 0)
                
            }
        }.background(Color.white)
            .cornerRadius(15)
    }
}

struct MainDetail: View {
    var body: some View {
        Image("logoRosKeramik")
            .resizable()
            .frame(width: 420, height: 80)
            .font(.title)
                      .background(Color(red: 43.0/255.0, green: 43.0/255.0, blue: 43.0/255.0))
    }
}

struct ItemDetail: View {
        @State private var age = 1
    var body: some View{
        VStack{
            VStack(alignment: .trailing, spacing: 10){
                HStack{
                    Text("Цена за \(self.age) единиц(у/ы)")
                    Spacer()
                    Text("\(self.age * 447)").fontWeight(.bold)
                    
                }.padding(.horizontal, 20)
                Text("-------------------------------------------------").padding(.horizontal, 20)
                HStack{
                Text("Количество: ")
                    Spacer()
                   Text("\(self.age)")
                }.padding(.horizontal, 20)
               
            }
                Stepper("Выберите между +/-:",onIncrement: {
                    self.age += 1
                }, onDecrement: {
                    self.age -= 1
                }).padding(.horizontal)
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
                Text("Матовая")
            }
            HStack{
                Text("Стиль:")
                Spacer()
                Text("Керамика")
            }
            Text("-------------------------------------------------")
        }.padding(.horizontal, 20)
            Spacer()
            Button(action: {
                //code
            }) {
                Text("Оформить").foregroundColor(.white).frame(width: 150, height: 60).background(Color.yellow).cornerRadius(15)
            }
            }
        }
}


struct Home: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State var index = 0
    @State var page = 0
    @State var show = false
    @State var isCart = false
    @State var isCart2 = false
    @State var isCart3 = false
    @State var isCart4 = false
    @State var isCart5 = false
    @State var isCart6 = false
    @State var isCart7 = false
    @State var isCart8 = false
    
    @State var wood = false
    @State var piastra = false
    @State var lazzaro = false
    @State var statuario = false
    @State var cassana = false
    
    @State var medis = false
    @State var alva = false
    @State var torres = false
    @State var stark = false
    @State private var age = 1
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 0) {
                
                Image("ApeVerona")
                    .resizable()
                    .frame(height: 250)
                
                // новинки, самые последние поступления, карусель
                VStack{
                    Text("Новинки:").fontWeight(.bold)
                        .font(.title).padding(30)
                    
                    Text("Самые последние поступления:")
                        .font(.system(size: 16)).padding(.bottom, 60)
                    
                    // carousel
                    GeometryReader { geometry in
                        ImageCarouselView(numberOfImages: 5) {
                            
                            // 1
                            VStack{
                                Button(action: {
                                    withAnimation(.spring()) {
                                        self.wood.toggle()
                                    }
                                }) {
                                    
                                    Image("wood")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                }.sheet(isPresented: self.$wood) {
                                    WoodDetail()
                                }
                                
                                HStack{
                                    Text("Wood").font(.title).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                                    Spacer()
                                    Button(action: {
                                        
                                        self.isCart.toggle()
                                    }) {
                                                                                            Image(systemName: "cart.badge.plus")
                                                .resizable()
                                                .frame(width: 40, height: 30)
                                                .foregroundColor(.yellow)
                                                    .padding(.trailing)
                                            .sheet(isPresented: self.$isCart) {
                                                VStack{
                                                    MainDetail()
                                                    Spacer()
                                                  Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                    Spacer()
                                                    ImageCarouselView(numberOfImages: 2) {
                                                        Image("wood")
                                                        .renderingMode(.original)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                                        .clipped().padding(.bottom, 20)
                                                        Image("wood")
                                                        .renderingMode(.original)
                                                        .resizable()
                                                        .scaledToFill()
                                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                                        .clipped().padding(.bottom, 20)
                                    
                                                    }.padding(.bottom, 20)
                                                    Spacer()
                                                ItemDetail()
                                                }
                                        }
                                    }

                                }
                                HStack{
                                    Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                                    Spacer()
                                    Text("от 447 с").fontWeight(.bold)
                                }.padding(.horizontal).foregroundColor(.black)
                            }
                            // 2
                            VStack{
                                Button(action: {
                                    withAnimation(.spring()) {
                                        self.piastra.toggle()
                                    }
                                }) {
                                    
                                    Image("piastra")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                }.sheet(isPresented: self.$piastra) {
                                    PiastraDetail()
                                }
                                
                                HStack{
                                    Text("Piastra Pearl").font(.system(size: 24)).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                                    Spacer()
                                    Button(action: {
                                        withAnimation(.spring()) {
                                            self.isCart2.toggle()
                                        }
                                    }) {
                                    Image(systemName: "cart.badge.plus")
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .foregroundColor(.yellow)
                                        .padding(.trailing)                                            .sheet(isPresented: self.$isCart2) {
                                                    VStack{
                                                        MainDetail()
                                                        Spacer()
                                                      Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                        Spacer()
                                                        ImageCarouselView(numberOfImages: 2) {
                                                            Image("piastra")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                                            Image("piastra")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                        
                                                        }.padding(.bottom, 20)
                                                        Spacer()
                                                    ItemDetail()
                                                    }
                                            }
                                    }
                                }
                                HStack{
                                    Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                                    Spacer()
                                    Text("от 747 с").fontWeight(.bold)
                                }.padding(.horizontal).foregroundColor(.black)
                            }
                            
                            //3
                            VStack{
                                Button(action: {
                                    withAnimation(.spring()) {
                                        self.lazzaro.toggle()
                                    }
                                }) {
                                    
                                    Image("lazzaro")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                }.sheet(isPresented: self.$lazzaro) {
                                    LazzaroDetail()
                                }
                                
                                HStack{
                                    Text("Lazzaro").font(.title).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                                    Spacer()
                                    Button(action: {
                                        self.isCart3.toggle()
                                    }) {
                                    Image(systemName: "cart.badge.plus")
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .foregroundColor(.yellow)
                                        .padding(.trailing).sheet(isPresented: self.$isCart3) {
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
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                                            Image("lazzaro")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                        
                                                        }.padding(.bottom, 20)
                                                        Spacer()
                                                    ItemDetail()
                                                    }
                                            }
                                    }
                                }
                                HStack{
                                    Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                                    Spacer()
                                    Text("от 847 с").fontWeight(.bold)
                                }.padding(.horizontal).foregroundColor(.black)
                            }
                            
                            //4
                            VStack{
                                Button(action: {
                                    withAnimation(.spring()) {
                                        self.cassana.toggle()
                                    }
                                }) {
                                    
                                    Image("cassana")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                }.sheet(isPresented: self.$cassana) {
                                    CassanaDetail()
                                }
                                
                                HStack{
                                    Text("Cassana").font(.title).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                                    Spacer()
                                    Button(action: {
                                        self.isCart4.toggle()
                                    }) {
                                    Image(systemName: "cart.badge.plus")
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .foregroundColor(.yellow)
                                        .padding(.trailing).sheet(isPresented: self.$isCart4) {
                                                    VStack{
                                                        MainDetail()
                                                        Spacer()
                                                      Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                        Spacer()
                                                        ImageCarouselView(numberOfImages: 2) {
                                                            Image("cassana")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                                            Image("cassana")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                        
                                                        }.padding(.bottom, 20)
                                                        Spacer()
                                                    ItemDetail()
                                                    }
                                            }
                                    }
                                }
                                HStack{
                                    Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                                    Spacer()
                                    Text("от 647 с").fontWeight(.bold)
                                }.padding(.horizontal).foregroundColor(.black)
                            }
                            
                            //5
                            VStack{
                                Button(action: {
                                    withAnimation(.spring()) {
                                        self.statuario.toggle()
                                    }
                                }) {
                                    
                                    Image("statuario")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                }.sheet(isPresented: self.$statuario) {
                                    StatuarioDetail()
                                }
                                
                                HStack{
                                    Text("Statuario").font(.title).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                                    Spacer()
                                    Button(action: {
                                        self.isCart5.toggle()
                                    }) {
                                    Image(systemName: "cart.badge.plus")
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .foregroundColor(.yellow)
                                        .padding(.trailing).sheet(isPresented: self.$isCart5) {
                                                    VStack{
                                                        MainDetail()
                                                        Spacer()
                                                      Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                        Spacer()
                                                        ImageCarouselView(numberOfImages: 2) {
                                                            Image("statuario")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                                            Image("statuario")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                        
                                                        }.padding(.bottom, 20)
                                                        Spacer()
                                                    ItemDetail()
                                                    }
                                        }}
                                }
                                HStack{
                                    Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                                    Spacer()
                                    Text("от 547 с").fontWeight(.bold)
                                }.padding(.horizontal).foregroundColor(.black)
                            }
                            
                            
                        }
                    }.frame(height: 250, alignment: .center).padding(.bottom, 60)
                }.background(Color(red: 244.0/255.0, green: 243.0/255.0, blue: 251.0/255.0))
                
                // скидки, самые выгодные предложения
                VStack{
                    
                    Text("Скидки:").fontWeight(.bold)
                        .font(.title).padding(.top,40)
                    
                    Text("Самые выгодные предложения!")
                        .font(.system(size: 16)).padding(20)
                    
                }.padding(.bottom,50)
                
                // популярная коллекция, карусель
                VStack{
                    Text("Популярная коллекция:").fontWeight(.bold)
                        .font(.title).padding(.top,40)
                    
                    Text("Самые популярные товары!")
                        .font(.system(size: 16)).padding(20).padding(.bottom, 40)
                    // carousel
                    GeometryReader { geometry in
                        ImageCarouselView(numberOfImages: 4) {
                            // 1
                            VStack{
                                Button(action: {
                                    withAnimation(.spring()) {
                                        self.torres.toggle()
                                    }
                                }) {
                                    
                                    Image("SkidkiTorres1-4")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                }.sheet(isPresented: self.$torres) {
                                    TorresDetail()
                                }
                                
                                HStack{
                                    Text("Torres").font(.title).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                                    Spacer()
                                    Button(action: {
                                        self.isCart6.toggle()
                                    }) {
                                    Image(systemName: "cart.badge.plus")
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .foregroundColor(.yellow)
                                        .padding(.trailing).sheet(isPresented: self.$isCart6) {
                                                    VStack{
                                                        MainDetail()
                                                        Spacer()
                                                      Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                        Spacer()
                                                        ImageCarouselView(numberOfImages: 2) {
                                                            Image("SkidkiTorres1-4")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                                            Image("SkidkiTorres1-4")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                        
                                                        }.padding(.bottom, 20)
                                                        Spacer()
                                                    ItemDetail()
                                                    }
                                            }
                                    }
                                }
                                HStack{
                                    Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                                    Spacer()
                                    Text("от 667 с").fontWeight(.bold)
                                }.padding(.horizontal).foregroundColor(.black)
                            }
                            // 2
                            VStack{
                                Button(action: {
                                    self.stark.toggle()
                                }) {
                                    Image("SkidkiStark2-4")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                }.sheet(isPresented: self.$stark) {
                                    StarkDetail()
                                }
                                HStack{
                                    Text("Stark").font(.title).fontWeight(.bold).padding(.leading,20)
                                    Spacer()
                                    Button(action: {
                                        self.isCart7.toggle()
                                    }) {
                                    Image(systemName: "cart.badge.plus")
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .foregroundColor(.yellow)
                                        .padding(.trailing).sheet(isPresented: self.$isCart7) {
                                                    VStack{
                                                        MainDetail()
                                                        Spacer()
                                                      Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                        Spacer()
                                                        ImageCarouselView(numberOfImages: 2) {
                                                            Image("SkidkiStark2-4")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                                            Image("SkidkiStark2-4")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                        
                                                        }.padding(.bottom, 20)
                                                        Spacer()
                                                    ItemDetail()
                                                    }
                                            }
                                    }
                                }
                                HStack{
                                    Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                                    Spacer()
                                    Text("от 967 с").fontWeight(.bold)
                                }.padding(.horizontal)
                                
                            }
                            // 3
                            VStack{
                                Button(action: {
                                    self.alva.toggle()
                                }) {
                                    Image("SkidkiAlva3-4")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                }.sheet(isPresented: self.$alva) {
                                    AlvaDetail()
                                }
                                HStack{
                                    Text("Alva").font(.title).fontWeight(.bold).padding(.leading,20)
                                    Spacer()
                                    Button(action: {
                                        self.isCart8.toggle()
                                    }) {
                                    Image(systemName: "cart.badge.plus")
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .foregroundColor(.yellow)
                                        .padding(.trailing).sheet(isPresented: self.$isCart8) {
                                                    VStack{
                                                        MainDetail()
                                                        Spacer()
                                                      Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                        Spacer()
                                                        ImageCarouselView(numberOfImages: 2) {
                                                            Image("SkidkiAlva3-4")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                                            Image("SkidkiAlva3-4")
                                                            .renderingMode(.original)
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: geometry.size.width, height: geometry.size.height)
                                                            .clipped().padding(.bottom, 20)
                                        
                                                        }.padding(.bottom, 20)
                                                        Spacer()
                                                    ItemDetail()
                                                    }
                                            }
                                    }
                                }
                                HStack{
                                    Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                                    Spacer()
                                    Text("от 767 с").fontWeight(.bold)
                                }.padding(.horizontal)
                            }
                            // 4
                            VStack{
                                Button(action: {
                                    self.medis.toggle()
                                }) {
                                    Image("SkidkiMedis4-4")
                                        .renderingMode(.original)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: geometry.size.width, height: geometry.size.height)
                                        .clipped()
                                }.sheet(isPresented: self.$medis) {
                                    MedisDetail()
                                }
                                HStack{
                                    Text("Medis").font(.title).fontWeight(.bold).padding(.leading,20)
                                    Spacer()
                                    
                                    Image(systemName: "cart.badge.plus")
                                        .resizable()
                                        .frame(width: 40, height: 30)
                                        .foregroundColor(.yellow)
                                        .padding(.trailing)
                                }
                                HStack{
                                    Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                                    Spacer()
                                    Text("от 467 с").fontWeight(.bold)
                                }.padding(.horizontal)
                            }
                        }
                    }.frame(height: 250, alignment: .center).padding(.bottom, 60)
                }.background(Color(red: 244.0/255.0, green: 243.0/255.0, blue: 251.0/255.0)).padding(.bottom, 30)
                
            }
        }
        
    }
}

struct KeramikTile: View {
    
    @State var wood = false
    @State var piastra = false
    @State var lazzaro = false
    @State var statuario = false
    @State var cassana = false
    
    @State var isCart = false
    @State var isCart2 = false
    @State var isCart3 = false
    @State var isCart4 = false
    @State var isCart5 = false
    
    @State private var age = 1
    
    var body: some View {
        
        ScrollView{
            
            VStack(spacing: 20){
                // 1
                VStack{
                    Button(action: {
                        withAnimation(.spring()) {
                            self.wood.toggle()
                        }
                    }) {
                        
                        Image("wood")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 300)
                            .clipped()
                    }.sheet(isPresented: self.$wood) {
                        WoodDetail()
                    }
                    
                    HStack{
                        Text("Wood").font(.title).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            self.isCart.toggle()
                        }) {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.yellow)
                            .padding(.trailing).sheet(isPresented: self.$isCart) {
                                            VStack{
                                                MainDetail()
                                                Spacer()
                                              Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                Spacer()
                                                ImageCarouselView(numberOfImages: 2) {
                                                    Image("wood")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 420, height: 250)
                                                    .clipped().padding(.bottom, 20)
                                                    Image("wood")
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
                    HStack{
                        Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                        Spacer()
                        Text("от 447 с").fontWeight(.bold)
                    }.padding(.horizontal).foregroundColor(.black)
                }
                // 2
                VStack{
                    Button(action: {
                        withAnimation(.spring()) {
                            self.piastra.toggle()
                        }
                    }) {
                        
                        Image("piastra")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 300)
                            .clipped()
                    }.sheet(isPresented: self.$piastra) {
                        PiastraDetail()
                    }
                    
                    HStack{
                        Text("Piastra Pearl").font(.system(size: 24)).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            self.isCart2.toggle()
                        }) {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.yellow)
                            .padding(.trailing).sheet(isPresented: self.$isCart2) {
                                            VStack{
                                                MainDetail()
                                                Spacer()
                                              Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                Spacer()
                                                ImageCarouselView(numberOfImages: 2) {
                                                    Image("piastra")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 420, height: 250)
                                                    .clipped().padding(.bottom, 20)
                                                    Image("piastra")
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
                    HStack{
                        Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                        Spacer()
                        Text("от 747 с").fontWeight(.bold)
                    }.padding(.horizontal).foregroundColor(.black)
                }
                
                //3
                VStack{
                    Button(action: {
                        withAnimation(.spring()) {
                            self.lazzaro.toggle()
                        }
                    }) {
                        
                        Image("lazzaro")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width:350, height: 300)
                            .clipped()
                    }.sheet(isPresented: self.$lazzaro) {
                        LazzaroDetail()
                    }
                    
                    HStack{
                        Text("Lazzaro").font(.title).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                        Spacer()
                        
                        Button(action: {
                            self.isCart3.toggle()
                        }) {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.yellow)
                            .padding(.trailing).sheet(isPresented: self.$isCart3) {
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
                    HStack{
                        Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                        Spacer()
                        Text("от 847 с").fontWeight(.bold)
                    }.padding(.horizontal).foregroundColor(.black)
                }
                
                //4
                VStack{
                    Button(action: {
                        withAnimation(.spring()) {
                            self.cassana.toggle()
                        }
                    }) {
                        
                        Image("cassana")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 300)
                            .clipped()
                    }.sheet(isPresented: self.$cassana) {
                        CassanaDetail()
                    }
                    
                    HStack{
                        Text("Cassana").font(.title).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                        Spacer()
                        
                        Button(action: {
                            self.isCart4.toggle()
                        }) {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.yellow)
                            .padding(.trailing).sheet(isPresented: self.$isCart4) {
                                            VStack{
                                                MainDetail()
                                                Spacer()
                                              Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                Spacer()
                                                ImageCarouselView(numberOfImages: 2) {
                                                    Image("cassana")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 420, height: 250)
                                                    .clipped().padding(.bottom, 20)
                                                    Image("cassana")
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
                    HStack{
                        Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                        Spacer()
                        Text("от 647 с").fontWeight(.bold)
                    }.padding(.horizontal).foregroundColor(.black)
                }
                
                // 5
                
                VStack{
                    Button(action: {
                        withAnimation(.spring()) {
                            self.statuario.toggle()
                        }
                    }) {
                        
                        Image("statuario")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 300)
                            .clipped()
                    }.sheet(isPresented: self.$statuario) {
                        StatuarioDetail()
                    }
                    
                    HStack{
                        Text("Statuario").font(.title).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                        Spacer()
                        Button(action: {
                            self.isCart5.toggle()
                        }) {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.yellow)
                            .padding(.trailing).sheet(isPresented: self.$isCart) {
                                            VStack{
                                                MainDetail()
                                                Spacer()
                                              Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                Spacer()
                                                ImageCarouselView(numberOfImages: 2) {
                                                    Image("statuario")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 420, height: 250)
                                                    .clipped().padding(.bottom, 20)
                                                    Image("statuario")
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
                    HStack{
                        Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                        Spacer()
                        Text("от 547 с").fontWeight(.bold)
                    }.padding(.horizontal).foregroundColor(.black)
                }
                
                
            }.padding(.horizontal).padding(.top, 20).padding(.bottom, 60)
        }
    }
}

struct Keramogranit: View {
    
    @State var medis = false
    @State var alva = false
    @State var torres = false
    @State var stark = false
    
    @State var isCart = false
    @State var isCart2 = false
    @State var isCart3 = false
    @State var isCart4 = false
    
    @State private var age = 1
    
    var body: some View {
        
        
        ScrollView{
            
            VStack(spacing: 20){
                
                // 1
                VStack{
                    Button(action: {
                        withAnimation(.spring()) {
                            self.torres.toggle()
                        }
                    }) {
                        
                        Image("SkidkiTorres1-4")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 300)
                            .clipped()
                    }.sheet(isPresented: self.$torres) {
                        TorresDetail()
                    }
                    
                    HStack{
                        Text("Torres").font(.title).fontWeight(.bold).padding(.leading,20).foregroundColor(.black)
                        Spacer()
                        
                        Button(action: {
                            self.isCart.toggle()
                        }) {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.yellow)
                            .padding(.trailing).sheet(isPresented: self.$isCart) {
                                            VStack{
                                                MainDetail()
                                                Spacer()
                                              Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                Spacer()
                                                ImageCarouselView(numberOfImages: 2) {
                                                    Image("SkidkiTorres1-4")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 420, height: 250)
                                                    .clipped().padding(.bottom, 20)
                                                    Image("SkidkiTorres1-4")
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
                    HStack{
                        Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                        Spacer()
                        Text("от 667 с").fontWeight(.bold)
                    }.padding(.horizontal).foregroundColor(.black)
                }
                // 2
                VStack{
                    Button(action: {
                        self.stark.toggle()
                    }) {
                        Image("SkidkiStark2-4")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 300)
                            .clipped()
                    }.sheet(isPresented: self.$stark) {
                        StarkDetail()
                    }
                    HStack{
                        Text("Stark").font(.title).fontWeight(.bold).padding(.leading,20)
                        Spacer()
                        
                        Button(action: {
                            self.isCart2.toggle()
                        }) {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.yellow)
                            .padding(.trailing).sheet(isPresented: self.$isCart2) {
                                            VStack{
                                                MainDetail()
                                                Spacer()
                                              Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                Spacer()
                                                ImageCarouselView(numberOfImages: 2) {
                                                    Image("SkidkiStark2-4")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 420, height: 250)
                                                    .clipped().padding(.bottom, 20)
                                                    Image("SkidkiStark2-4")
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
                    HStack{
                        Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                        Spacer()
                        Text("от 967 с").fontWeight(.bold)
                    }.padding(.horizontal)
                    
                }
                // 3
                VStack{
                    Button(action: {
                        self.alva.toggle()
                    }) {
                        Image("SkidkiAlva3-4")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 300)
                            .clipped()
                    }.sheet(isPresented: self.$alva) {
                        AlvaDetail()
                    }
                    HStack{
                        Text("Alva").font(.title).fontWeight(.bold).padding(.leading,20)
                        Spacer()
                        Button(action: {
                            self.isCart3.toggle()
                        }) {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.yellow)
                            .padding(.trailing).sheet(isPresented: self.$isCart3) {
                                            VStack{
                                                MainDetail()
                                                Spacer()
                                              Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                Spacer()
                                                ImageCarouselView(numberOfImages: 2) {
                                                    Image("piastra")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 420, height: 250)
                                                    .clipped().padding(.bottom, 20)
                                                    Image("piastra")
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
                    HStack{
                        Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                        Spacer()
                        Text("от 767 с").fontWeight(.bold)
                    }.padding(.horizontal)
                }
                // 4
                VStack{
                    Button(action: {
                        self.medis.toggle()
                    }) {
                        Image("SkidkiMedis4-4")
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 300)
                            .clipped()
                    }.sheet(isPresented: self.$medis) {
                        MedisDetail()
                    }
                    HStack{
                        Text("Medis").font(.title).fontWeight(.bold).padding(.leading,20)
                        Spacer()
                        Button(action: {
                            self.isCart4.toggle()
                        }) {
                        Image(systemName: "cart.badge.plus")
                            .resizable()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.yellow)
                            .padding(.trailing).sheet(isPresented: self.$isCart4) {
                                            VStack{
                                                MainDetail()
                                                Spacer()
                                              Text("Оформление заказа:").font(.title).fontWeight(.semibold).foregroundColor(.yellow).padding(.top, 5)
                                                Spacer()
                                                ImageCarouselView(numberOfImages: 2) {
                                                    Image("piastra")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 420, height: 250)
                                                    .clipped().padding(.bottom, 20)
                                                    Image("piastra")
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
                    HStack{
                        Text("Цена:").foregroundColor(.gray).padding(.leading, 10)
                        Spacer()
                        Text("от 467 с").fontWeight(.bold)
                    }.padding(.horizontal)
                }
                
            }.padding(.horizontal).padding(.top, 20).padding(.bottom, 60)
        }
    }
}

struct WarmFloor: View {
    
    var body: some View {
        
        GeometryReader{_ in
            
            VStack {
                Text("Теплый пол")
            }
        }
    }
}
// о компании
struct AboutUs: View {
    
    var body: some View {
        
        GeometryReader{_ in
            ScrollView{
                VStack {
                    Text("О компании")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .padding(.top, 10)
                    Text("""

Сеть магазинов «Росскерамика» представлена на рынке отделочных материалов с июня 2006 года.

Почему плитку стоит покупать именно в Росскерамике в ТЦ Аю Гранд Комфорт? Этот магазин открыт в начале 2016 года,каждому покупателю мы делаем бесплатно дизайн с цветной распечаткой, сам торговый центр имеет максимальные удобства для клиентов - удобные подъездные пути, просторный паркинг, кондиционируемое помещение где летом прохладно, а зимой тепло, под одной крышей работают более 200 строительных магазинов, в торговом комплексе есть кафе, детская площадка с воспитателем, который смотрит за Вашими детьми, пока Вы делаете покупки.

Для Вашего удобства мы постарались собрать в одном месте все лучшие керамические коллекции от ведущих производителей России.

Мы предлагаем керамические материалы для любых целей - для отделки внутренних и наружных поверхностей.

Распахнутые двери магазина «Росскерамика» в ТЦ Аю Гранд Комфорт предлагают Вам все самое новое, модное и революционное для оформления интерьеров и экстерьеров.

Мы работаем, для того, чтобы Вы могли ориентироваться в мире современного дизайна, оригинальных идей и стилистических решений.

Откройте для себя мир керамической моды!

Так же приглашаем к выгодному сотрудничеству дизайнеров, строителей и коммерческие организации.


""")
                }.padding()
            }
        }
    }
}



var data = ["Основная информация", "Керамическая плитка", "Керамогранит", "Теплый пол", "О нас"]

