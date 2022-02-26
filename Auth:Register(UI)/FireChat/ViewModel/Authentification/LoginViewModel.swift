//
//  LoginViewModel.swift
//  FireChat
//
//  Created by Sabir Myrzaev on 26/2/22.
//

import Foundation

protocol AuthentificationProtocol {
    var formIsValid: Bool { get }
}

struct LoginViewModel: AuthentificationProtocol {
    var email: String?
    var password: String?
    
    var formIsValid: Bool {
        return email?.isEmpty == false
            && password?.isEmpty == false
    }
}
