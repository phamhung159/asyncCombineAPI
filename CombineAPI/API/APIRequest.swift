//
//  APIRequest.swift
//  CombineAPI
//
//  Created by Hung, Pham Van on 27/09/2022.
//

import Foundation
import Combine
import Alamofire

typealias STError = AFError

class APIRequest {
    @discardableResult
    static func requestAsync<T: Decodable> (_ router: URLRequestConvertible,
                                            responseModel: T.Type)
                                                async -> Result<T, PHResponseError> {
        return await withCheckedContinuation { continuation in
            PHSession.request(router).responseDecodable(of: T.self) { dataResponse in
                if let error = dataResponse.error {
                    let code = dataResponse.response?.statusCode ?? 999
                    let status = PHResultCode(rawValue: code) ?? .unknow
                    let error = PHResponseError(status: status, message: error.localizedDescription)
                    continuation.resume(returning: .failure(error))
                    return
                }
                
                // Request failure
                if let httpStatusCode = dataResponse.response?.statusCode,
                    !processHTTPError(code: httpStatusCode) {
                    var message: String?
                    if let data = dataResponse.data {
                        let dec = JSONDecoder()
                        let response = try? dec.decode(ResponseModel<BaseResponse>.self, from: data)
                        message = response?.message
                    }
                    let code = dataResponse.response?.statusCode ?? 999
                    let status = PHResultCode(rawValue: code) ?? .unknow
                    let error = PHResponseError(status: status, message: message)
                    continuation.resume(returning: .failure(error))
                    return
                }
                if let data = dataResponse.data,
                   let error = processError(data: data) {
                    continuation.resume(returning: .failure(error))
                    return
                }
                // Process parse data
                if let responseModel = dataResponse.value {
                    continuation.resume(returning: .success(responseModel))
                    return
                } else {
                    let code = dataResponse.response?.statusCode ?? 999
                    let status = PHResultCode(rawValue: code) ?? .unknow
                    let error = PHResponseError(status: status, message: "nil data")
                    continuation.resume(returning: .failure(error))
                    return
                }
            }
        }
    }
    
    static func requestCombine<T: Decodable>( _ router: URLRequestConvertible,
                                              decoder: JSONDecoder = JSONDecoder())
                                                -> AnyPublisher<Result<T, AFError>, Never> {
        return PHSession.request(router)
            .validate(APIRequest.validate(request:response:data:))
            .publishDecodable(type: T.self, decoder: decoder)
            .result()
    }
    
    static func requestCombineVer2<T: Decodable>(  _ router: URLRequestConvertible,
                                                   type: T.Type)
                                                -> AnyPublisher<Result<T, AFError>, Never> {
        return PHSession.request(router)
            .validate(APIRequest.validate(request:response:data:))
            .publishDecodable(type: T.self)
            .result()
    }
    
    static func requestAsyncVer2<T: Decodable>( _ router: URLRequestConvertible, responseModel: T.Type) async throws -> T {
        let value = try await PHSession.request(router)
            .validate(APIRequest.validate(request:response:data:))
            .serializingDecodable(T.self).value
        return value
    }
}

extension APIRequest {
    fileprivate static func validate(request: URLRequest?,
                                     response: HTTPURLResponse,
                                     data: Data?) -> Request.ValidationResult {
        guard let dataResponse = data else {
            let status = PHResultCode(rawValue: response.statusCode) ?? .unknow
            let error = PHResponseError(status: status, message: "nil data")
            return .failure(error)
        }
        let httpStatusCode = response.statusCode
        if !processHTTPError(code: httpStatusCode) {
            let json = JSONDecoder()
            let response = try? json.decode(ResponseModel<BaseResponse>.self, from: dataResponse)
            let message = response?.message
            let status = PHResultCode(rawValue: httpStatusCode) ?? .unknow
            let error = PHResponseError(status: status, message: message)
            return .failure(error)
        }
        if let error = processError(data: dataResponse) {
            return .failure(error)
        }
        return .success(Void())
    }
    
    fileprivate static func processError(data: Data) -> PHResponseError? {
        if let response = try? JSONDecoder().decode(ResponseModel<BaseResponse>.self, from: data) {
            if !processError(code: response.code) {
                let message = response.message
                let status = PHResultCode(rawValue: response.code) ?? .unknow
                let error = PHResponseError(status: status, message: message)
                return error
            }
        }
        return nil
    }
    
    fileprivate static func processError(code: Int) -> Bool {
        switch code {
            //TODO: hander error code
        default: return true
        }
    }
    
    fileprivate static func processHTTPError(code: Int) -> Bool {
        if code >= 400 || code < 200 {
            return false
        }
        return true
    }
}


