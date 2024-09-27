import Foundation

struct MockData<T:Decodable>{
    static func mockDataForJsonFile(fileName:String) throws -> T {
        if let mockDataURL = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let mockData = try Data(contentsOf: mockDataURL)
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                
                if let json =  try? jsonDecoder.decode(T.self, from: mockData){
                    return json
                } else {
                    throw AppError.parseError
                }
            } catch {
                throw AppError.error("jsonDataError")
            }
        } else {
            throw AppError.error("jsonFileError")
        }
    }
}
