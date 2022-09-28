//
//  APIKey.swift
//  CombineAPI
//
//  Created by Hung, Pham Van on 27/09/2022.
//

import Foundation

typealias PHParamater = [APIKey: Any]

class APIBase {
    static let hasLogin                     = "HasLogin_Base"
    static let BASE_URL                     = "https://api.dev.example.com"
}

enum APIKey: String {
    case id
    case code
}

extension Dictionary where Key == APIKey {
    var asParamater: [String: Any] {
        var param = [String: Any]()
        self.forEach { (key, value) in
            param[key.rawValue] = value
        }
        return param
    }
}

