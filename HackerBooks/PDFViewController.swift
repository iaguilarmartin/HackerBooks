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
        
        self.edgesForExtendedLayout = UIRectEdge()
        
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Subscribe to selectedBookChanged notifications
        NotificationCenter.default.addObserver(self, selector: #selector(newBookSelected), name: NSNotification.Name(rawValue: selectedBookChanged), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Unsubscribe to all notifications
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: - Functions
    
    // function to update controller title and WebView content
    func updateView() {
        self.title = self.model.title
        
        if let maybePDF = try? DataDownloader.downloadExternalFileFromURL(self.model.document), let pdf = maybePDF {
            
            let baseURL = self.model.document.deletingLastPathComponent()
            pdfWebView.load(pdf, mimeType: "application/pdf", textEncodingName: "", baseURL: baseURL)
        }
    }
    
    // Function called when selectedBookChanged notification arrives
    func newBookSelected(_ notificarion: Notification) {
        let info = (notificarion as NSNotification).userInfo
        
        if let book = info?[selectedBookKey] as? Book {
            self.model = book
            updateView()
        }
        
    }
    
}
