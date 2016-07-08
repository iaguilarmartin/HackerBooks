//
//  Library.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 28/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import Foundation

typealias BooksArray = [Book]

class Library: BookDelegate {
    let favoritesTag = "favorites"
    let favoritesUserDefaultsKey = "FavoriteBooks"
    
    var tags = [String]()
    var books = BooksArray()
    var dictionary = [String: BooksArray]()
    var isLibraryChanged = false
    
    let sortClosure = { (book1: Book, book2: Book) -> Bool in
        return book1.title < book2.title
    }
    
    init (json: NSData) {
        if let jsonArray = try? JSONManager.loadFromData(json) {
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let favoritesArray = userDefaults.arrayForKey(favoritesUserDefaultsKey) as? [String]
            
            dictionary[favoritesTag] = BooksArray()
            
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

                        if let favoritesArray = favoritesArray where favoritesArray.contains(book.proxyForComparasion) {
                            book.isFavorite = true
                            dictionary[favoritesTag]?.append(book)
                        }
                        
                        book.delegate = self
                        
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
            
            sort()
            
            tags.insert(favoritesTag, atIndex: 0)
        }
    }
    
    func numberOfTags() -> Int {
        return tags.count
    }
    
    func numberOfBooks() -> Int {
        return books.count
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
    
    func getBookAtIndex(index: Int) -> Book {
        return books[index]
    }
    
    func getBookFromTag(tag: String, atIndex i: Int) -> Book? {
        return dictionary[tag]?[i]
    }
    
    func sort() {
        tags.sortInPlace()
        
        books.sortInPlace(sortClosure)
        
        for tag in self.tags {
            dictionary[tag]?.sortInPlace(sortClosure)
        }
    }
    
    func bookDelegate(book: Book, favoriteValueChanged newValue: Bool) {
        if newValue {
            dictionary[favoritesTag]?.append(book)
        } else {
            dictionary[favoritesTag] = dictionary[favoritesTag]?.filter({ $0 !== book })
        }
        
        dictionary[favoritesTag]?.sortInPlace(sortClosure)
        
        isLibraryChanged = true

        let favoritesArray = dictionary[favoritesTag]!.map({ favoriteBook in
            favoriteBook.proxyForComparasion
        })
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(favoritesArray, forKey: favoritesUserDefaultsKey)
    }
    
    func getFirstBook() -> Book? {
        if dictionary[favoritesTag]?.count > 0 {
            return dictionary[favoritesTag]?[0]
        } else if tags.count > 1 {
            return dictionary[tags[1]]![0]
        }
        
        return nil
    }
}