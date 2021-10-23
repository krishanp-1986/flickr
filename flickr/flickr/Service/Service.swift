//
//  Service.swift
//  flickr
//
//  Created by Krishan Sunil Premaretna on 2021-10-23.
//

import Foundation

protocol Service {
    var dataProvider: DataProvider! { get set }
    init()
}

extension Service {
    init(with dataProvider: DataProvider) {
        self.init()
        self.dataProvider = dataProvider
    }
}
