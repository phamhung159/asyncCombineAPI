//
//  ExampleEndPoint.swift
//  CombineAPI
//
//  Created by Hung, Pham Van on 27/09/2022.
//

import Foundation
import Alamofire

class PHEndPoint: URLRequestConvertible {
    
    var path: String = ""
    var requireAccessToken: Bool = true
    var method: HTTPMethod = .get
    var body: PHParamater?
    var pathParams: [String] = []
    
    init(path: String = "",
         method: HTTPMethod = .get,
         pathParams: [String]? = nil,
         body: PHParamater? = nil,
         isToken: Bool = true) {
        self.path               = path
        self.method             = method
        self.pathParams         = pathParams ?? []
        self.body               = body
        self.requireAccessToken = isToken
    }
    
    func asURLRequest() throws -> URLRequest {
        var url: URL = try PHRequestURLConfig.rootApi.asURL()
        var urlRequest: URLRequest?
        url.appendPathComponent(path)
        for item in pathParams {
            url = url.appendingPathComponent(item)
        }
        
        urlRequest = URLRequest(url: url)
        urlRequest!.httpMethod = method.rawValue
        let content     = "application/json;charset=utf-8"
        let accept      = "application/json"
        let charset     = "utf-8"
        urlRequest?.headers.update(.accept(accept))
        urlRequest?.headers.update(.acceptCharset(charset))
        urlRequest?.headers.update(.contentType(content))
        //TODO: add token access
//        if requireAccessToken, let token = LoginManager.shared.loginTeller?.token {
//            urlRequest!.addValue(token, forHTTPHeaderField: "Authorization")
//        }
        PHLogger.log("--> Request: " + url.absoluteString)
        if let params = body {
            let bodyData = try JSONSerialization.data(withJSONObject: params.asParamater,
                                                      options: .prettyPrinted)
            let jsonStr = String(data: bodyData, encoding: .utf8) ?? ""
            PHLogger.log("--> body: \(jsonStr)")
            
            if (method == .post || method == .put) {
                urlRequest?.httpBody = bodyData
            } else {
                if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !params.asParamater.isEmpty {
                    let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(params.asParamater)
                    urlComponents.percentEncodedQuery = percentEncodedQuery
                    urlRequest?.url = urlComponents.url
                }
            }
        } else {
            urlRequest!.headers.update(.contentType("multipart/form-data"))
        }
        
        return urlRequest!
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []

        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += URLEncoding.default.queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
}
