//
//  JSONManager.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 29/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation

//MARK: - Aliases
typealias JSONObject = AnyObject
typealias JSONDictionary = [String : JSONObject]
typealias JSONArray = [JSONDictionary]

struct JSONManager {
    static func loadFromData(data: NSData) throws -> JSONArray {
        guard let jsonData = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) else {
            throw ApplicationErrors.wrongJSONData
        }
        
        if jsonData.isKindOfClass(NSDictionary) {
            guard let jsonDict = jsonData as? JSONDictionary else {
                throw ApplicationErrors.wrongJSONData
            }
            
            return [jsonDict]
            
        } else if jsonData.isKindOfClass(NSArray) {
            guard let jsonArr = jsonData as? JSONArray else {
                throw ApplicationErrors.wrongJSONData
            }
            
            return jsonArr
        } else {
            throw ApplicationErrors.unrecognizedJSONData
        }
    }
}