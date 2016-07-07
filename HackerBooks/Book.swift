//
//  Book.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 28/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation

class Book: Equatable {
    
    static let bookChangedEvent = "BookChangedNotification"
    static let bookChangedKey = "KeyBook"
    
    let title: String
    let authors: [String]
    let tags: [String]
    let image: NSURL
    let document: NSURL
    var delegate: BookDelegate?
    var isFavorite: Bool = false {
        didSet {
            if let delegate = delegate {
                delegate.bookDelegate(self, favoriteValueChanged: self.isFavorite)
            }
            
            NSNotificationCenter.defaultCenter().postNotificationName(Book.bookChangedEvent, object: self, userInfo: [Book.bookChangedKey: self])
        }
    }
    
    init (title: String, authors: [String], tags: [String], image: NSURL, document: NSURL) {
        self.title = title
        self.authors = authors
        self.tags = tags
        self.image = image
        self.document = document
    }
    
    //MARK: - Proxies
    var proxyForComparasion: String {
        get {
            return "\(title)\(authors.joinWithSeparator(","))\(tags.joinWithSeparator(","))"
        }
    }
}

func ==(lhs: Book, rhs: Book) -> Bool {
    return lhs.proxyForComparasion == rhs.proxyForComparasion
}

protocol BookDelegate {
    func bookDelegate(book: Book, favoriteValueChanged newValue:Bool)
}