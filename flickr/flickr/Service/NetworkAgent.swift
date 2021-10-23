//
//  NetworkAgent.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

struct NetworkAgent: DataProvider {
    private let session = URLSession.shared
    func execute<T>(_ request: URLRequest, whenDone: @escaping (Result<T, ServiceError>) -> Void) where T: Decodable {
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let responseError = error {
                    whenDone(.failure(.generalError(responseError)))
                    return
                }
                guard response != nil else {
                    whenDone(.failure(.invalidResponse))
                    return
                }
                let httpUrlResponseCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                guard 200..<300 ~= httpUrlResponseCode else {
                    whenDone(.failure(.unSuccessfulResponse(httpUrlResponseCode)))
                    return
                }
                guard let responseData = data, responseData.count > 0 else {
                    whenDone(.failure(.inValidData))
                    return
                }
                do {
                    let responseModel = try JSONDecoder().decode(T.self, from: responseData)
                    whenDone(.success(responseModel))
                } catch let error {
                    whenDone(.failure(.generalError(error)))
                }

            }
        }
        task.resume()
    }
}
