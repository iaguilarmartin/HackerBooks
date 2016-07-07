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
    
    init(model: Library) {
        self.model = model
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
        return self.model.numberOfTags()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tagName = self.model.nameOfTagAt(index: section)
        return self.model.numberOfBookFromTag(tagName)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.model.nameOfTagAt(index: section)
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
        let tagName = self.model.nameOfTagAt(index: path.section)
        return self.model.getBookFromTag(tagName, atIndex: path.row)!
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
}

protocol LibraryViewControllerDelegate {
    
    func libraryViewController(libraryVC: LibraryViewController, didSelectBook book: Book)
    
}
