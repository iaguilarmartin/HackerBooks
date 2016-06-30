//
//  BookViewController.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 30/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit

class BookViewController: UIViewController {

    let model: Book
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    
    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        self.title = model.title
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = .None
        
        setTextValue(self.titleLabel, text: self.model.title)
        setTextValue(self.authorsLabel, text: self.model.authors.joinWithSeparator(", "))
        setTextValue(self.tagsLabel, text: self.model.tags.joinWithSeparator(", "))
        
        if let maybeImage = try? DataDownloader.downloadExternalFileFromURL(self.model.image), image = maybeImage {
            self.bookImage.image  = UIImage(data: image)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setTextValue(label: UILabel, text: String) {
        label.text = text
        label.numberOfLines = 0;
        label.sizeToFit()
    }
}
