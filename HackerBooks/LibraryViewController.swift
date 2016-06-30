//
//  LibraryViewController.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 30/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit

class LibraryViewController: UITableViewController {

    let bookCellId = "BookCell"
    
    let model: Library
    
    init(model: Library) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        self.title = "Hacker Books Library"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.model.numberOfTags()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let tagName = self.model.nameOfTagAt(index: section)
        return self.model.numberOfBookFromTag(tagName)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.model.nameOfTagAt(index: section)
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(bookCellId)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: bookCellId)
        }
        
        let tagName = self.model.nameOfTagAt(index: indexPath.section)
        if let book = self.model.getBookFromTag(tagName, atIndex: indexPath.row) {
            cell?.textLabel?.text = book.title
            
            if let maybeImage = try? DataDownloader.downloadExternalFileFromURL(book.image), image = maybeImage {
                cell?.imageView?.image = UIImage(data: image)
            }
        }
        
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tagName = self.model.nameOfTagAt(index: indexPath.section)
        if let book = self.model.getBookFromTag(tagName, atIndex: indexPath.row) {
            let bookVC = BookViewController(model: book)
            self.navigationController?.pushViewController(bookVC, animated: true)
        }
    }
}
