//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 30/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, LibraryViewControllerDelegate, UISplitViewControllerDelegate {

    var model: Book?
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    init(model: Book?) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = .None
        
        updateView()
        
        if self.splitViewController?.displayMode == .PrimaryHidden {
            self.navigationItem.rightBarButtonItem = self.splitViewController?.displayModeButtonItem()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func readBook(sender: AnyObject) {
        
        if let book = self.model {
            let pdfVC = PDFViewController(model: book)
            self.navigationController?.pushViewController(pdfVC, animated: true)
        }
    }
    
    func updateView() {
        if let book = self.model {
            self.title = book.title
            self.view.hidden = false
            
            self.titleLabel.text = book.title
            self.authorsLabel.text = book.authors.joinWithSeparator(", ")
            self.tagsLabel.text = book.tags.joinWithSeparator(", ")
            
            if let maybeImage = try? DataDownloader.downloadExternalFileFromURL(book.image), image = maybeImage {
                self.bookImage.image  = UIImage(data: image)
            }
        } else {
            self.title = "Ningún libro seleccionado"
            self.view.hidden = true
        }
    }
    
    //MARK: - LibraryViewControllerDelegate
    func libraryViewController(libraryVC: LibraryViewController, didSelectBook book: Book) {
        self.model = book
        updateView()
    }
    
    //MARK: - UISplitViewControllerDelegate
    func splitViewController(svc: UISplitViewController, willChangeToDisplayMode displayMode: UISplitViewControllerDisplayMode) {
        
        if displayMode == .PrimaryHidden {
            self.navigationItem.rightBarButtonItem = self.splitViewController?.displayModeButtonItem()
        } else if displayMode == .AllVisible {
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }
}
