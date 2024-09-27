import Foundation

protocol APIService {
    func fetchDataRequest<T:Decodable> (url:URL) async throws -> T
}
