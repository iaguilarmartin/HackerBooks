//
//  DataDownloader.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 28/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation

struct DataDownloader {
    
    static private let remoteJSONURLString = "https://t.co/K9ziV0z3SJ"
    static private let appInitializedKey = "app_initialized"
    static private let localJSONFileName = "library.json"
    
    static func loadApplicationData() throws ->  NSData? {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
        let localJSONFilePath = NSURL(fileURLWithPath: documentsPath, isDirectory: true).URLByAppendingPathComponent(localJSONFileName)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        //userDefaults.setBool(false, forKey: appInitializedKey)
        
        if !userDefaults.boolForKey(appInitializedKey) {
 
            let jsonURL = NSURL(string: remoteJSONURLString)
            guard let url = jsonURL else {
                throw ApplicationErrors.invalidJSONURL
            }
            
            let jsonData = NSData(contentsOfURL: url)
        
            guard let result = jsonData?.writeToURL(localJSONFilePath, atomically: false) where result else {
                throw ApplicationErrors.cantSaveJSONFile
            }
            
            userDefaults.setBool(true, forKey: appInitializedKey)
        }
        
        return NSData(contentsOfURL: localJSONFilePath)
    }
}


