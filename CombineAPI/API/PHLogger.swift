//
//  Logger.swift
//  CombineAPI
//
//  Created by Hung, Pham Van on 27/09/2022.
//
import Foundation

class PHLogger {
    enum LogLevel: Int {
        case debug
        case production
    }
    
    static var logLevel: LogLevel {
        if let budnle = Bundle.main.bundleIdentifier {
            return budnle.contains("test") ? .debug : .production
        }
        return .production
    }
    
    static func log(_ message: String,
                    level: LogLevel = .production,
                    file: String = #file,
                    _ function: String = #function,
                    line: Int = #line) {
        let time = stringDate(date: Date(), formart: "HH:mm:ss")
        let fileName = fileNameWithoutSuffix(file)
        
        if logLevel.rawValue < level.rawValue {
            #if DEBUG
            print("Log: \(time) \(fileName).\(function): \(line) \(message)")
            #else
            NSLog("Log: \(time) \(fileName).\(function): \(line) \(message)")
            #endif
        }
    }
    
    private static func fileNameOfFile(_ file: String) -> String {
        let fileParts = file.components(separatedBy: "/")
        if let lastPart = fileParts.last {
            return lastPart
        }
        return ""
    }

    private static func fileNameWithoutSuffix(_ file: String) -> String {
        let fileName = fileNameOfFile(file)

        if !fileName.isEmpty {
            let fileNameParts = fileName.components(separatedBy: ".")
            if let firstPart = fileNameParts.first {
                return firstPart
            }
        }
        return ""
    }
    
    private static func stringDate(date: Date, formart: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formart
        return dateFormatter.string(from: date)
    }
}
