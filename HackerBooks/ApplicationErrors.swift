import Foundation

// Enum with the most common errors tracked inside the app

enum ApplicationErrors : ErrorType {
    case invalidJSONURL
    case noLocalJSONFile
    case cantSaveJSONFile
    case wrongJSONData
    case unrecognizedJSONData
    case wrongFileName
}