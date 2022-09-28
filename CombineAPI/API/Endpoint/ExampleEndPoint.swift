//
//  ExampleEndPoint.swift
//  CombineAPI
//
//  Created by Hung, Pham Van on 27/09/2022.
//

import Foundation

class ExampleEndPoint: PHEndPoint {
    struct APIPath {
        static let getExample           = ""
    }
    
    class func getExample() -> ExampleEndPoint {
        let params = PHParamater()
        return ExampleEndPoint(path: APIPath.getExample,
                            method: .get, body: params)
    }
}
