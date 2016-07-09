import UIKit

// View Controller to display PDF files
class PDFViewController: UIViewController {
    
    //MARK: - Properties
    var model: Book
    
    //MARK: - IBOutlets
    @IBOutlet weak var pdfWebView: UIWebView!
    
    //MARK: - Initializers
    init(model: Book) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .None
        
        updateView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to selectedBookChanged notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(newBookSelected), name: selectedBookChanged, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe to all notifications
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //MARK: - Functions
    
    // function to update controller title and WebView content
    func updateView() {
        self.title = self.model.title
        
        if let maybePDF = try? DataDownloader.downloadExternalFileFromURL(self.model.document), pdf = maybePDF, baseURL = self.model.document.URLByDeletingLastPathComponent {
            
            pdfWebView.loadData(pdf, MIMEType: "application/pdf", textEncodingName: "", baseURL: baseURL)
        }
    }
    
    // Function called when selectedBookChanged notification arrives
    func newBookSelected(notificarion: NSNotification) {
        let info = notificarion.userInfo
        
        if let book = info?[selectedBookKey] as? Book {
            self.model = book
            updateView()
        }
        
    }
    
}
