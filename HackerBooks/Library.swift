import Foundation

//MARK: - Custom types
typealias BooksArray = [Book]

// Class to group information os all the books that forms the library
class Library: BookDelegate {
    
    //MARK: - Constants
    let favoritesTag = "favorites"
    let favoritesUserDefaultsKey = "FavoriteBooks"
    
    //MARK: - Properties
    var tags = [String]()
    var books = BooksArray()
    var dictionary = [String: BooksArray]()
    var isLibraryChanged = false
    
    //MARK: - Initializer
    init (json: NSData) {
        // Getting JSON object from a JSON file
        if let jsonArray = try? JSONManager.loadFromData(json) {
            
            // Retrieve favorite books from persistant storage
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let favoritesArray = userDefaults.arrayForKey(favoritesUserDefaultsKey) as? [String]
            
            // Add favorite group to the dictionary
            dictionary[favoritesTag] = BooksArray()
            
            // Proccess each JSON object inside the array
            for dict:JSONDictionary in jsonArray {
                
                // if the format of the JSON object is correct a new book is created
                if let title = dict["title"] as? String,
                    tagsString = dict["tags"] as? String,
                    authorsString = dict["authors"] as? String,
                    imageURL = dict["image_url"] as? String,
                    docURL = dict["pdf_url"] as? String {
                    
                    // Converts authos and tags strings to arrays
                    let authors = authorsString.componentsSeparatedByString(", ")
                    let tags = tagsString.componentsSeparatedByString(", ")
                    
                    // Check if the image and document string value are valid URLs
                    if let image = NSURL(string: imageURL), document = NSURL(string: docURL) {
                        let book = Book(title: title, authors: authors, tags: tags, image: image, document: document)

                        // Check if book was a previously saved as favorite
                        if let favoritesArray = favoritesArray where favoritesArray.contains(book.proxyForComparasion) {
                            book.isFavorite = true
                            dictionary[favoritesTag]?.append(book)
                        }
                        
                        // Set the library as book's delegate
                        book.delegate = self
                        
                        // Add the book to the array
                        books.append(book)
                        
                        // Add the book to all the tag groups that it belongs
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
            
            // Sort library
            sort()
            
            // Insert favorite tag to the first position of the tags array
            tags.insert(favoritesTag, atIndex: 0)
        }
    }
    
    //MARK: - Closures
    let sortClosure = { (book1: Book, book2: Book) -> Bool in
        return book1.title < book2.title
    }
    
    //MARK: - Functions
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
    
    // Sorts tags Array, books Array and each array inside dictionary
    func sort() {
        tags.sortInPlace()
        
        books.sortInPlace(sortClosure)
        
        for tag in self.tags {
            dictionary[tag]?.sortInPlace(sortClosure)
        }
    }
    
    // Returns the first book of the distionary
    func getFirstBook() -> Book? {
        if dictionary[favoritesTag]?.count > 0 {
            return dictionary[favoritesTag]?[0]
        } else if tags.count > 1 {
            return dictionary[tags[1]]![0]
        }
        
        return nil
    }
    
    //MARK: - BookDelegate
    func bookDelegate(book: Book, favoriteValueChanged newValue: Bool) {
        
        // If it is a new favorite book then it is added to the dictionary
        // else it is removed from the dictionary
        if newValue {
            dictionary[favoritesTag]?.append(book)
            dictionary[favoritesTag]?.sortInPlace(sortClosure)
        } else {
            dictionary[favoritesTag] = dictionary[favoritesTag]?.filter({ $0 !== book })
        }
        
        // Inform that the library has been modified
        isLibraryChanged = true

        // Favorites books are saved in persistant storage
        let favoritesArray = dictionary[favoritesTag]!.map({ favoriteBook in
            favoriteBook.proxyForComparasion
        })
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(favoritesArray, forKey: favoritesUserDefaultsKey)
    }
    

}