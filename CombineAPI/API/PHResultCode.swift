//
//  ResultCode.swift
//  CombineAPI
//
//  Created by Hung, Pham Van on 27/09/2022.
//

import Foundation

enum PHResultCode: Int, Codable {
    case httpSuccess = 200
    case httpCreated = 201
    case httpAccepted = 202
    case httpNoContent = 204
    case unknow = 999
    case httpInternalError = 500
    case httpBadRequest = 400
    case httpNotFound = 404
    case httpForbidden = 403
    case httpUnauthorized = 401
    case parseError = 998
    case quota_exceeded     = 429
}
