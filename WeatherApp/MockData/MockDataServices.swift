import Foundation

struct MockDataAPIService: APIService {
    let jsonFileName:String
    func fetchDataRequest<T:Decodable>(url: URL) async throws -> T {
        do {
            let data = try MockData<T>.mockDataForJsonFile(fileName:jsonFileName)
            return data
        } catch {
            throw error
        }
    }
}

struct MockDataAPIErrorService: APIService {
    func fetchDataRequest<T:Decodable>(url: URL) async throws -> T {
        throw AppError.serverError
    }
}
