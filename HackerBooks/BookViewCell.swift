import UIKit

// Custom Cell View to display books information in LibraryViewController

class BookViewCell: UITableViewCell {

    static let cellId: String = "CustomBookCell"
    static let cellHeight: CGFloat = 65
    
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var bookAuthors: UILabel!
    @IBOutlet weak var bookImage: UIImageView!
    
}
