//
//  DataProvider.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

protocol DataProvider {
    func cancel()
    func execute<T: Decodable>(_ request: URLRequest, whenDone: @escaping (Result<T, ServiceError>) -> Void)
}

enum ServiceError: Error {
    case invalidResponse
    case unSuccessfulResponse(Int)
    case inValidData
    case generalError(Error)
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Invalid Response"
        case .inValidData:
            return "Server failed to return Data"
        case .unSuccessfulResponse(let errorCode):
            return "Server replied with errorCode : \(errorCode)"
        case .generalError(let error):
            return error.localizedDescription
        }
    }
}

extension ServiceError: Equatable {
    static func == (lhs: ServiceError, rhs: ServiceError) -> Bool {
        (lhs as NSError).code == (rhs as NSError).code
    }
}
