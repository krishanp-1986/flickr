//
//  Constants.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

struct Constants {
    
    struct StringConstants {
        struct URLConstants {
            static let text = "text"
            static let page = "page"
            static let per_page = "per_page"
            static let format = "format"
            static let json = "json"
            static let apiKey = "api_key"
            static let method = "method"
        }
    }
    
    struct NSErrorConstants {
        static let nsErrorDomain = "com.mobiquity.flickr"
        static let failedRequestErrorCode = -999
    }
}
