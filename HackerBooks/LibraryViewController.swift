import UIKit

let selectedBookChanged = "SelectedBookChangedNotification"
let selectedBookKey = "book"

// TableViewController to display books library
class LibraryViewController: UITableViewController {

    //MARK: - Properties
    let model: Library
    var delegate: LibraryViewControllerDelegate?
    var segmentedControl: UISegmentedControl
    
    // Computed property to indicate if view is in alphabetical display mode
    var areTagsVisibles: Bool {
        get {
            return segmentedControl.selectedSegmentIndex == 0
        }
    }
    
    //MARK: - Initializers
    init(model: Library) {
        self.model = model
        self.segmentedControl = UISegmentedControl(items: ["Tags", "Alphabetical"])
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Hacker Books Library"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register default cell type
        let nib = UINib(nibName: "BookViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: BookViewCell.cellId)
        
        // Replace the TitleView of the NavigationController with a SegmentedControl
        // to indicate if displaying books grouped by tag or ordered by title
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.addTarget(self, action: #selector(selectedSegmentChanged), for: .valueChanged)
        
        self.navigationItem.titleView = self.segmentedControl
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to bookChangedEvent notifications
        NotificationCenter.default.addObserver(self, selector: #selector(bookChanged), name: NSNotification.Name(rawValue: Book.bookChangedEvent), object: nil)
        
        // Update table each time the view would be displayed
        reloadTable()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe to all notifications
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if areTagsVisibles {
            return self.model.numberOfTags()
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if areTagsVisibles {
            let tagName = self.model.nameOfTagAt(index: section)
            return self.model.numberOfBookFromTag(tagName)
        } else {
            return self.model.numberOfBooks()
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if areTagsVisibles {
            return self.model.nameOfTagAt(index: section)
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return BookViewCell.cellHeight
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Try to reuse an existing cell
        let cell: BookViewCell? = tableView.dequeueReusableCell(withIdentifier: BookViewCell.cellId, for: indexPath) as? BookViewCell
        
        // Get book to be displayed
        let book = getBookAtIndexPath(indexPath)
        
        // Filling cell with book info
        fillCell(cell, book: book)
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Get selected book
        let book = getBookAtIndexPath(indexPath)
        
        // If current device is an iPad then existing BookViewController is informed that a
        // new book is selected. Else, app navigates to the a new BookViewController
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.delegate?.libraryViewController(self, didSelectBook: book)
            
            let notif = Notification(name: Notification.Name(rawValue: selectedBookChanged), object: self, userInfo: [selectedBookKey: book])
            let notifCenter = NotificationCenter.default
            notifCenter.post(notif)
        } else {
            let bookVC = BookViewController(model: book)
            self.navigationController?.pushViewController(bookVC, animated: true)
        }
    }
    
    //MARK: - Functions
    func fillCell(_ cell: BookViewCell?, book: Book) {
        cell?.bookName.text = book.title
        cell?.bookAuthors.text = book.authors.joined(separator: ", ")
        
        if let maybeImage = try? DataDownloader.downloadExternalFileFromURL(book.image), let image = maybeImage {
            cell?.bookImage.image = UIImage(data: image)
        }
    }
    
    func getBookAtIndexPath(_ path: IndexPath) -> Book {
        if areTagsVisibles {
            let tagName = self.model.nameOfTagAt(index: (path as NSIndexPath).section)
            return self.model.getBookFromTag(tagName, atIndex: (path as NSIndexPath).row)!
        } else {
            return self.model.getBookAtIndex((path as NSIndexPath).row)
        }
    }
    
    func bookChanged(_ notif: Notification) {
        reloadTable()
    }
    
    func reloadTable() {
        // Check if model has changed before reloading the data into the table
        if self.model.isLibraryChanged {
            self.tableView.reloadData()
            self.model.isLibraryChanged = false
        }
    }
    
    // Function called when the way of displaying books is changed. When that occurs
    // the table data needs to be reloaded
    func selectedSegmentChanged() {
        
        //Scroll the TableView to the first element
        self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: false)
        self.tableView.reloadData()
    }
}

protocol LibraryViewControllerDelegate {
    func libraryViewController(_ libraryVC: LibraryViewController, didSelectBook book: Book)
}
