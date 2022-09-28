//
//  RequestURLConfig.swift
//  CombineAPI
//
//  Created by Hung, Pham Van on 27/09/2022.
//

import Foundation

enum Target: String {
    case honban     = "Honban"
    case staging    = "Staging"
}

class PHRequestURLConfig {
    static let targetName = Bundle.main.object(forInfoDictionaryKey: "TargetName") as? String ?? ""
    
    static var target: Target {
        switch targetName {
        case Target.honban.rawValue:
            return .honban
        case Target.staging.rawValue:
            return .staging
        default:
            return .staging
        }
    }
    
    static var rootApi: String {
        switch target {
        case .honban:
            return "https://example.com"
        case .staging:
            return "https://api.dev.example.com"
        }
    }
    
}
