//
//  TokenPlugin.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import Moya

struct TokenPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
//        if let token = ??? {
//            request.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
//        }
        return request
    }
}
