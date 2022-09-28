//
//  Session.swift
//  CombineAPI
//
//  Created by Hung, Pham Van on 27/09/2022.
//

import Foundation
import Alamofire

let IntervalTimeOut: TimeInterval = 30

class PHSession {
    internal static var manager: Alamofire.Session = {
        var configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = IntervalTimeOut
        let delegate = LoggingSessionDelegate()
        let sessionManager = Alamofire.Session(configuration: configuration,
                                               delegate: delegate)
        return sessionManager
    }()
    
    class func request(_ url: URLRequestConvertible) -> DataRequest {
        return manager.request(url)
    }
    
    class func cancelAllRequest() {
        manager.session.invalidateAndCancel()
    }
    
    deinit {
        NSLog("Session deinit")
    }
}

class LoggingSessionDelegate: Alamofire.SessionDelegate {
    override func urlSession(_ session: URLSession,
                             dataTask: URLSessionDataTask, didReceive data: Data) {
        #if DEBUG
        logResponse(session, dataTask: dataTask, didReceiveData: data)
        #endif
        super.urlSession(session, dataTask: dataTask, didReceive: data)
    }
    
    fileprivate func logResponse(_ session: Foundation.URLSession,
                                 dataTask: URLSessionDataTask, didReceiveData data: Data) {
        do {
            PHLogger.log("--> Request: " + (dataTask.currentRequest?.url?.absoluteString ?? ""))
            let dataAsJSON = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON,
                                                         options: .prettyPrinted)
            if let jsonString = NSString(data: prettyData,
                                         encoding: String.Encoding.utf8.rawValue) {
                PHLogger.log("--> Response: \(jsonString)")
            }
        } catch {
            PHLogger.log("\(error)")
        }
    }
}
