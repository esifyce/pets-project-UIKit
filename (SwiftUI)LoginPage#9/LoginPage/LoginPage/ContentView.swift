//
//  ContentView.swift
//  LoginPage
//
//  Created by Sabir Myrzaev on 03.05.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import SwiftUI

let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0)

let storedUserName = "Dzheffri"
let storedUserPassword = "damer"


struct ContentView: View {
    
    @State var userName: String = ""
    @State var userPassword: String = ""
    
    @State var authenticationDidFail: Bool = false
    @State var authenticationDidSuccesed: Bool = false
    
    var body: some View {
        
        ZStack{
        VStack{
            helloText()
            userImage()
            userNameTextField(userName: $userName)
            userPasswordSecureField(userPassword: $userPassword)
            
            if authenticationDidFail{
                Text("No correct! Try again.")
                    .offset(y: -10)
                    .foregroundColor(Color.red)
            }
            
            
            
            Button(action: {
                
                if self.userName == storedUserName && self.userPassword == storedUserPassword{
                     self.authenticationDidFail = false
                    self.authenticationDidSuccesed = true
                } else{
                     self.authenticationDidSuccesed = false
                    self.authenticationDidFail = true
                   
                }
                
                
            }) {
                 loginButtonContent()
            }
            
           
        }
        .padding()
            if authenticationDidSuccesed{
                Text("Login succesed!")
                    .font(.headline)
                    .foregroundColor(Color.green)
                    .cornerRadius(20.0)
                    .animation(Animation.default)
            }
    }
}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct helloText: View {
    var body: some View {
        Text("Hello you!")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct userImage: View {
    var body: some View {
        Image("dzheffri")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 150, height: 150)
            .clipped()
            .cornerRadius(150)
            .padding(.bottom, 75)
    }
}

struct loginButtonContent: View {
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(Color.black)
            .cornerRadius(35)
    }
}

struct userNameTextField: View {
    
    @Binding var userName: String
    
    var body: some View {
        TextField("Username", text: $userName)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct userPasswordSecureField: View {
    
    @Binding var userPassword: String
    
    var body: some View {
        SecureField("Password", text: $userPassword)
            .padding()
            .background(lightGreyColor)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}
