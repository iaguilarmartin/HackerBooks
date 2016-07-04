//
//  BookViewCell.swift
//  HackerBooks
//
//  Created by Ivan Aguilar Martin on 4/7/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit

class BookViewCell: UITableViewCell {

    static let cellId: String = "CustomBookCell"
    static let cellHeight: CGFloat = 65
    
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
