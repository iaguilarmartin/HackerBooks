//
//  Book.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 28/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation

class Book {
    
    let title: String
    let authors: [String]
    let tags: [String]
    let image: NSURL
    let document: NSURL
    
    init (title: String, authors: [String], tags: [String], image: NSURL, document: NSURL) {
        self.title = title
        self.authors = authors
        self.tags = tags
        self.image = image
        self.document = document
    }
}