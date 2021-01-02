//
//  ModelData.swift
//  BoggleWordGame
//
//  Created by Dileep Jaiswal on 02/01/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import Foundation

struct ResponseData: Decodable {
    var words: [ModelData]
}

struct ModelData : Decodable {
    var list: [String]
    var title: String
}
