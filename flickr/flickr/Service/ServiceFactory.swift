//
//  ServiceFactory.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

struct ServiceFactory {

    static func useCaseFor<T>(_ type: T.Type) -> T where T: Service {
        let dataProvider: DataProvider = NetworkAgent()
        return type.init(with: dataProvider)
    }
}
