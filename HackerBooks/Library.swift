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
    
    var books = BooksArray()
    var tags = [String]()
    var dictionary = [String: BooksArray]()
    
    init (json: NSData) {
        if let jsonArray = try? JSONManager.loadFromData(json) {
            
            for dict:JSONDictionary in jsonArray {
                if let title = dict["title"] as? String,
                    tagsString = dict["tags"] as? String,
                    authorsString = dict["authors"] as? String,
                    imageURL = dict["image_url"] as? String,
                    docURL = dict["pdf_url"] as? String {
                    
                    let authors = authorsString.componentsSeparatedByString(", ")
                    let tags = tagsString.componentsSeparatedByString(", ")
                    
                    if let image = NSURL(string: imageURL), document = NSURL(string: docURL) {
                        let book = Book(title: title, authors: authors, tags: tags, image: image, document: document)
                        books.append(book)
                    }
                }
            }
        }
    }
}