//
//  titleMenu.swift
//  SideMenuUi
//
//  Created by Sabir Myrzaev on 11.05.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import SwiftUI

struct titleMenu {
        @Binding var show: Bool
    var body: some View {
        
                        HStack{
            
            Button(action: {
                withAnimation(.spring()) {
                    //show.toggle($show)
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
                //code
            }) {
                Image(systemName: "cart")
                    .resizable()
                    .frame(width: 25, height: 20)
                    .foregroundColor(.white)
                    .padding(.trailing)
            }
        }

}
}
