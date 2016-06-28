//
//  Library.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 28/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation

class Library {
    typealias BooksArray = [Book]
    
    let books = [BooksArray]()
    let tags = [String]()
    let dictionary = [String: BooksArray]()
    
    init (json: NSData) {
        
    }
}