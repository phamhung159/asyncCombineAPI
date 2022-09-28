//
//  APIResponse.swift
//  CombineAPI
//
//  Created by Hung, Pham Van on 27/09/2022.
//

import Foundation

struct ResponseModel<M: Codable>: Codable {
    var message: String?
    var code: Int
    var data: M?
    
    private enum CodingKeys: String, CodingKey {
        case message
        case code
        case data
    }
}

struct PHResponseError: Codable {
    var code: PHResultCode
    var name: String?
    var message: String?
    
    private enum CodingKeys: String, CodingKey {
        case code
        case name
        case message
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decodeIfPresent(PHResultCode.self, forKey: .code) ?? PHResultCode.unknow
        name = try container.decodeIfPresent(String.self, forKey: .name)
        message = try container.decodeIfPresent(String.self, forKey: .message)
    }
    
    init(status: PHResultCode, message: String?) {
        self.code = status
        self.message = message
    }
}

extension PHResponseError: Error {
    
}

struct BaseResponse: Codable {
    var message: String?
}
