//
//  ApplicationErrors.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 28/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation

enum ApplicationErrors : ErrorType {
    case invalidJSONURL
    case noLocalJSONFile
    case cantSaveJSONFile
    case wrongJSONData
    case unrecognizedJSONData
}