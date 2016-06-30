//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 30/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit

class BookViewController: UIViewController, LibraryViewControllerDelegate, UISplitViewControllerDelegate {

    var model: Book
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    init(model: Book) {
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
        
        let pdfVC = PDFViewController(model: self.model)
        self.navigationController?.pushViewController(pdfVC, animated: true)
    }
    
    func updateView() {
        self.title = model.title
        
        self.titleLabel.text = self.model.title
        self.authorsLabel.text = self.model.authors.joinWithSeparator(", ")
        self.tagsLabel.text = self.model.tags.joinWithSeparator(", ")
        
        if let maybeImage = try? DataDownloader.downloadExternalFileFromURL(self.model.image), image = maybeImage {
            self.bookImage.image  = UIImage(data: image)
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
