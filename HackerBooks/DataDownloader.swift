import Foundation

// Struct with static methods to retrive data from remote servers

struct DataDownloader {
    
    static fileprivate let remoteJSONURLString = "https://t.co/K9ziV0z3SJ"
    static fileprivate let appInitializedKey = "app_initialized"
    static fileprivate let localJSONFileName = "library.json"
    
    // Documents path inside the application SandBox
    static let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    
    // function that downloads a file from a server and then saves it locally for future uses
    static func downloadApplicationData() throws ->  Data? {
        
        // local path where the file should be saved
        let localJSONFilePath = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent(localJSONFileName)
        
        // if it is the first time that the app is running then 
        // the JSON file needs to be downloaded
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: appInitializedKey) {
 
            // Downloading file from the server
            let jsonURL = URL(string: remoteJSONURLString)
            guard let url = jsonURL else {
                throw ApplicationErrors.invalidJSONURL
            }
            
            let jsonData = try? Data(contentsOf: url)
        
            // Trying to save the file localy
            guard let _ = try? jsonData?.write(to: localJSONFilePath, options: .atomic) else {
                throw ApplicationErrors.cantSaveJSONFile
            }
            
            // Setting the app as initialized
            userDefaults.set(true, forKey: appInitializedKey)
        }
        
        return (try? Data(contentsOf: localJSONFilePath))
    }
    
    // function to download files from an URL if it is not in app SandBox yet
    static func downloadExternalFileFromURL(_ url: URL) throws -> Data? {
        
        // get the name of the file from the URL
        let fileName = url.lastPathComponent
        if (fileName == "") {
            throw ApplicationErrors.wrongFileName
        }
        
        // search the file in the documents path of the application SandBox
        // if it is not there then it is downloaded from the server
        let localFilePath = URL(fileURLWithPath: documentsPath, isDirectory: true).appendingPathComponent(fileName)
        
        guard let localData = try? Data(contentsOf: localFilePath) else {
            
            let remoteData = try? Data(contentsOf: url)
            try? remoteData?.write(to: localFilePath, options: [])
            return remoteData
        }
        
        return localData
    }
}


