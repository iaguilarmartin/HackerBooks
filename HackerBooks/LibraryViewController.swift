//
//  LibraryViewController.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 30/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit

let selectedBookChanged = "SelectedBookChangedNotification"
let selectedBookKey = "book"

class LibraryViewController: UITableViewController, LibraryViewControllerDelegate {

    let model: Library
    var delegate: LibraryViewControllerDelegate?
    var segmentedControl: UISegmentedControl
    
    var areTagsVisibles: Bool {
        get {
            return segmentedControl.selectedSegmentIndex == 0
        }
    }
    
    init(model: Library) {
        self.model = model
        self.segmentedControl = UISegmentedControl(items: ["Tags", "Alphabetical"])
        
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Hacker Books Library"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "BookViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: BookViewCell.cellId)
        
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.addTarget(self, action: #selector(selectedSegmentChanged), forControlEvents: .ValueChanged)
        
        self.navigationItem.titleView = self.segmentedControl
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(bookChanged), name: Book.bookChangedEvent, object: nil)
        
        reloadTable()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if areTagsVisibles {
            return self.model.numberOfTags()
        } else {
            return 1
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if areTagsVisibles {
            let tagName = self.model.nameOfTagAt(index: section)
            return self.model.numberOfBookFromTag(tagName)
        } else {
            return self.model.numberOfBooks()
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if areTagsVisibles {
            return self.model.nameOfTagAt(index: section)
        } else {
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return BookViewCell.cellHeight
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: BookViewCell? = tableView.dequeueReusableCellWithIdentifier(BookViewCell.cellId, forIndexPath: indexPath) as? BookViewCell
        
        let book = getBookAtIndexPath(indexPath)
        fillCell(cell, book: book)
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let book = getBookAtIndexPath(indexPath)
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.delegate?.libraryViewController(self, didSelectBook: book)
            
            let notif = NSNotification(name: selectedBookChanged, object: self, userInfo: [selectedBookKey: book])
            let notifCenter = NSNotificationCenter.defaultCenter()
            notifCenter.postNotification(notif)
        } else {
            let bookVC = BookViewController(model: book)
            self.navigationController?.pushViewController(bookVC, animated: true)
        }
    }
    
    func libraryViewController(libraryVC: LibraryViewController, didSelectBook book: Book) {
        let bookVC = BookViewController(model: book)
        self.navigationController?.pushViewController(bookVC, animated: true)
    }
    
    func fillCell(cell: BookViewCell?, book: Book) {
        cell?.bookName.text = book.title
        cell?.bookAuthors.text = book.authors.joinWithSeparator(", ")
        
        if let maybeImage = try? DataDownloader.downloadExternalFileFromURL(book.image), image = maybeImage {
            cell?.bookImage.image = UIImage(data: image)
        }
    }
    
    func getBookAtIndexPath(path: NSIndexPath) -> Book {
        if areTagsVisibles {
            let tagName = self.model.nameOfTagAt(index: path.section)
            return self.model.getBookFromTag(tagName, atIndex: path.row)!
        } else {
            return self.model.getBookAtIndex(path.row)
        }
    }
    
    func bookChanged(notif: NSNotification) {
        reloadTable()
    }
    
    func reloadTable() {
        if self.model.isLibraryChanged {
            self.tableView.reloadData()
            self.model.isLibraryChanged = false
        }
    }
    
    func selectedSegmentChanged() {
        self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: false)
        self.tableView.reloadData()
    }
}

protocol LibraryViewControllerDelegate {
    
    func libraryViewController(libraryVC: LibraryViewController, didSelectBook book: Book)
    
}
