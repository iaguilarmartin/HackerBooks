import Foundation

//MARK: - Aliases
typealias JSONObject = AnyObject
typealias JSONDictionary = [String : JSONObject]
typealias JSONArray = [JSONDictionary]

// A struct with a method to convert a JSON file into an Array of JSON objects

struct JSONManager {
    static func loadFromData(_ data: Data) throws -> JSONArray {
        guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
            throw ApplicationErrors.wrongJSONData
        }
        
        if (jsonData is NSDictionary) {
            guard let jsonDict = jsonData as? JSONDictionary else {
                throw ApplicationErrors.wrongJSONData
            }
            
            return [jsonDict]
            
        } else if (jsonData is NSArray) {
            guard let jsonArr = jsonData as? JSONArray else {
                throw ApplicationErrors.wrongJSONData
            }
            
            return jsonArr
        } else {
            throw ApplicationErrors.unrecognizedJSONData
        }
    }
}
