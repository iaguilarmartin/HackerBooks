import Foundation

// Struct with static methods to retrive data from remote servers

struct DataDownloader {
    
    static private let remoteJSONURLString = "https://t.co/K9ziV0z3SJ"
    static private let appInitializedKey = "app_initialized"
    static private let localJSONFileName = "library.json"
    
    // Documents path inside the application SandBox
    static let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0]
    
    // function that downloads a file from a server and then saves it locally for future uses
    static func downloadApplicationData() throws ->  NSData? {
        
        // local path where the file should be saved
        let localJSONFilePath = NSURL(fileURLWithPath: documentsPath, isDirectory: true).URLByAppendingPathComponent(localJSONFileName)
        
        // if it is the first time that the app is running then 
        // the JSON file needs to be downloaded
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if !userDefaults.boolForKey(appInitializedKey) {
 
            // Downloading file from the server
            let jsonURL = NSURL(string: remoteJSONURLString)
            guard let url = jsonURL else {
                throw ApplicationErrors.invalidJSONURL
            }
            
            let jsonData = NSData(contentsOfURL: url)
        
            // Trying to save the file localy
            guard let result = jsonData?.writeToURL(localJSONFilePath, atomically: false) where result else {
                throw ApplicationErrors.cantSaveJSONFile
            }
            
            // Setting the app as initialized
            userDefaults.setBool(true, forKey: appInitializedKey)
        }
        
        return NSData(contentsOfURL: localJSONFilePath)
    }
    
    // function to download files from an URL if it is not in app SandBox yet
    static func downloadExternalFileFromURL(url: NSURL) throws -> NSData? {
        
        // get the name of the file from the URL
        guard let fileName = url.lastPathComponent else {
            throw ApplicationErrors.wrongFileName
        }
        
        // search the file in the documents path of the application SandBox
        // if it is not there then it is downloaded from the server
        let localFilePath = NSURL(fileURLWithPath: documentsPath, isDirectory: true).URLByAppendingPathComponent(fileName)
        
        guard let localData = NSData(contentsOfURL: localFilePath) else {
            
            let remoteData = NSData(contentsOfURL: url)
            remoteData?.writeToURL(localFilePath, atomically: false)
            return remoteData
        }
        
        return localData
    }
}


