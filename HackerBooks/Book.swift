import Foundation

// Class of the model to store the information of each book
class Book: Equatable {
    
    //MARK: - Notifications constants
    static let bookChangedEvent = "BookChangedNotification"
    static let bookChangedKey = "KeyBook"
    
    //MARK: - Book properties
    let title: String
    let authors: [String]
    let tags: [String]
    let image: URL
    let document: URL
    var delegate: BookDelegate?
    
    // Observing property to send a notification when the model is changed
    var isFavorite: Bool = false {
        didSet {
            
            // Notifying to book delegate
            if let delegate = delegate {
                delegate.bookDelegate(self, favoriteValueChanged: self.isFavorite)
            }
            
            // Notifying to everyone
            NotificationCenter.default.post(name: Notification.Name(rawValue: Book.bookChangedEvent), object: self, userInfo: [Book.bookChangedKey: self])
        }
    }
    
    //MARK: - Initializer
    init (title: String, authors: [String], tags: [String], image: URL, document: URL) {
        self.title = title
        self.authors = authors
        self.tags = tags
        self.image = image
        self.document = document
    }
    
    //MARK: - Proxy for comparison
    var proxyForComparasion: String {
        get {
            return "\(title)\(authors.joined(separator: ","))\(tags.joined(separator: ","))"
        }
    }
}

//MARK: - Equatable
func ==(lhs: Book, rhs: Book) -> Bool {
    return lhs.proxyForComparasion == rhs.proxyForComparasion
}

// Book delegate protocol to notify when model is changed
protocol BookDelegate {
    func bookDelegate(_ book: Book, favoriteValueChanged newValue:Bool)
}
