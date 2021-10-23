//
//  JsonUtils.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

import Foundation

struct JsonUtils {
    static func convertJsonIntoDecodable<T>(_ type: T.Type, fileName: String, bundle: Bundle = .main, inDirectory: String? = nil) -> T? where T: Decodable {
        guard let filePath = bundle.path(forResource: fileName, ofType: "json", inDirectory: inDirectory) else {
            return nil
        }
        
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: filePath)) else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
