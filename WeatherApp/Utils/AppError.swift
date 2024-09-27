import Foundation

enum AppError : Error, Equatable {
    case error(String)
    case redirection
    case clientError
    case badResponse
    case serverError
    case parseError
    case invalidUrl
    case fileDataError
    case geoCodeError
    case unknown
}

extension AppError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .error(let errStr):
            return String(localized:"\(errStr)")
        case .redirection:
            return String(localized: "redirection")
        case .serverError:
            return String(localized:"serverError")
        case .parseError:
            return String(localized:"parseError")
        case .invalidUrl:
            return String(localized:"invalidUrlError")
        case .badResponse:
            return String(localized:"badResponse")
        case .clientError:
            return String(localized:"clientError")
        case .unknown:
            return String(localized:"unknownError")
        case .fileDataError:
            return String(localized:"fileDataError")
        case .geoCodeError:
            return String(localized:"locationError")
        }
    }
}
