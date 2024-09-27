import Foundation

struct DataTaskAPIService : APIService {
    static let shared = DataTaskAPIService()
    private let session = URLSession.shared

    private init() {}
   
    private let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        // if needed, configure decoder for other settings .eg  decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    func fetchDataRequest<T:Decodable>(url:URL) async throws -> T {
            let (data,response) = try await session.data(from: url)
            guard let response = response as? HTTPURLResponse else {
                throw AppError.badResponse
            }
             switch response.statusCode {
             case (200...299):
                 do {
                     let apiResponse = try jsonDecoder.decode(T.self, from: data)
                     return apiResponse
                 } catch {
                     throw AppError.parseError
                 }
             case 300..<400:
                 throw AppError.redirection
             case 400..<500:
                 print(response.description)
                 throw AppError.clientError
             case 500..<600:
                 throw AppError.serverError
             default:
                 throw AppError.unknown
             }
    }
}

