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
                        
                        for each in tags {
                            if self.tags.indexOf(each) == nil {
                                self.tags.append(each)
                                dictionary[each] = [book]
                            } else {
                                dictionary[each]?.append(book)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func numberOfTags() -> Int {
        return tags.count
    }
    
    func numberOfBookFromTag(tag: String) -> Int {
        guard let count = dictionary[tag]?.count else {
            return 0
        }
        
        return count
    }
    
    func nameOfTagAt(index i: Int) -> String {
        return tags[i]
    }
    
    func getBookFromTag(tag: String, atIndex i: Int) -> Book? {
        return dictionary[tag]?[i]
    }
}