//
//  IBaseRouter.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import Moya

protocol IBaseRouter {
    typealias Parameters = [String: Any]
}

extension IBaseRouter where Self: TargetType {
    
    var baseURL: URL {
        Dependency.resolve(with: URL.self, with: .baseURL)
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
    
    var headers: [String: String]? { ["content-type": "application/json"] }
}
