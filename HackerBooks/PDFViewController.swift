//
//  PDFViewController.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 30/6/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {
    
    let model: Book
    
    @IBOutlet weak var pdfWebView: UIWebView!
    
    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        self.title = self.model.title
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let maybePDF = try? DataDownloader.downloadExternalFileFromURL(self.model.document), pdf = maybePDF, baseURL = self.model.document.URLByDeletingLastPathComponent {
            
            pdfWebView.loadData(pdf, MIMEType: "application/pdf", textEncodingName: "", baseURL: baseURL)
        }

    }
    
}
