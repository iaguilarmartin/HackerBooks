import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        do {
            window = UIWindow(frame: UIScreen.mainScreen().bounds)
            
            // Get JSON file with books data from local or remote
            if let json = try DataDownloader.downloadApplicationData() {
                
                // Create model parging JSON file
                let library = Library(json: json)
                
                // Create LibraryViewController and set as the rootViewController of a NavigationController
                let libraryVC = LibraryViewController(model: library)
                let libraryNav = UINavigationController(rootViewController: libraryVC)
                
                // If current device is an iPad then a SplitViewController is displayed
                // else LibraryViewController would be the main View Controller
                if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    
                    // We need a BookViewController to display at the rigt side of the
                    // SplitViewController
                    let bookVC = BookViewController(model: library.getFirstBook())
                    
                    let bookNav = UINavigationController(rootViewController: bookVC)
                    let splitVC = UISplitViewController()
                    splitVC.viewControllers = [libraryNav, bookNav]
                    window?.rootViewController = splitVC
                    
                    libraryVC.delegate = bookVC
                    
                } else {
                    window?.rootViewController = libraryNav
                }
                
                window?.makeKeyAndVisible()
                
            } else {
                fatalError("ERROR: Unable to load application data")
            }
        } catch ApplicationErrors.invalidJSONURL {
            print("ERROR: Invalid JSON URL")
            
        } catch ApplicationErrors.cantSaveJSONFile {
            print("ERROR: While trying to save JSON on documents folder")
            
        } catch {
            print("ERROR: Unknown error")
        }
        
        return true
    }
}

