//
//  PDFViewController.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 30/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {
    
    var model: Book
    
    @IBOutlet weak var pdfWebView: UIWebView!
    
    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        updateView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newBookSelected), name: selectedBookChanged, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func updateView() {
        self.title = self.model.title
        
        if let maybePDF = try? DataDownloader.downloadExternalFileFromURL(self.model.document), pdf = maybePDF, baseURL = self.model.document.URLByDeletingLastPathComponent {
            
            pdfWebView.loadData(pdf, MIMEType: "application/pdf", textEncodingName: "", baseURL: baseURL)
        }
    }
    
    func newBookSelected(notificarion: NSNotification) {
        let info = notificarion.userInfo
        
        if let book = info?[selectedBookKey] as? Book {
            self.model = book
            updateView()
        }
        
    }
    
}
