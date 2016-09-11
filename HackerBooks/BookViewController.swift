import UIKit

// View Controller to display detailed book information
class BookViewController: UIViewController, LibraryViewControllerDelegate, UISplitViewControllerDelegate {

    //MARK: - Properties
    var model: Book?
    
    //MARK: - IBOutlets
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    
    //MARK: - Initializers
    init(model: Book?) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        updateView()
        
        if self.splitViewController?.displayMode == .primaryHidden {
            self.navigationItem.rightBarButtonItem = self.splitViewController?.displayModeButtonItem
        }
    }
    
    //MARK: - IBActions
    @IBAction func readBook(_ sender: AnyObject) {
        
        if let book = self.model {
            let pdfVC = PDFViewController(model: book)
            self.navigationController?.pushViewController(pdfVC, animated: true)
        }
    }
    
    @IBAction func favoriteBook(_ sender: AnyObject) {
        if self.model != nil {
            self.model?.isFavorite = !(self.model?.isFavorite)!
            updateView()
        }
    }
    
    //MARK: - Functions
    
    // Function that updates the view based on model state
    func updateView() {
        if let book = self.model {
            self.title = book.title
            self.view.isHidden = false
            
            self.titleLabel.text = book.title
            self.authorsLabel.text = book.authors.joined(separator: ", ")
            self.tagsLabel.text = book.tags.joined(separator: ", ")
            
            if let maybeImage = try? DataDownloader.downloadExternalFileFromURL(book.image), let image = maybeImage {
                self.bookImage.image  = UIImage(data: image)
            }
            
            if book.isFavorite {
                favoritesButton.title = "Quitar de favoritos"
            } else {
                favoritesButton.title = "Añadir a favoritos"
            }
        
        // If no model is set then main view is hidden
        } else {
            self.title = "Ningún libro seleccionado"
            self.view.isHidden = true
        }
    }
    
    //MARK: - LibraryViewControllerDelegate
    func libraryViewController(_ libraryVC: LibraryViewController, didSelectBook book: Book) {
        self.model = book
        updateView()
    }
    
    //MARK: - UISplitViewControllerDelegate
    func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewControllerDisplayMode) {
        
        // If the screen is in portrait mode the library is displayed at the rigth
        // button of the NavigationBar
        if displayMode == .primaryHidden {
            self.navigationItem.rightBarButtonItem = self.splitViewController?.displayModeButtonItem
        } else if displayMode == .allVisible {
            self.navigationItem.rightBarButtonItem = nil
        }
        
    }
}
