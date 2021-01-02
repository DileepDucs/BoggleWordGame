//
//  APIService.swift
//  BoggleWordGame
//
//  Created by Dileep Jaiswal on 02/01/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit

enum APIError: String, Error {
    case noNetwork = "Network Not Reachable"
    case serverOverload = "Server is overloaded"
    case permissionDenied = "Permission Denied"
}

protocol APIServiceProtocol {
    func fetchAllWords(fileName: String, complete: @escaping ( _ success: Bool, _ list: [ModelData],
        _ error: APIError? )->() )
}

class APIService: APIServiceProtocol {
    func fetchAllWords(fileName: String, complete: @escaping ( _ success: Bool, _ list: [ModelData], _ error: APIError? )->() ) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(ResponseData.self, from: data)
                complete(true, jsonData.words, nil)
            } catch {
                print("error:\(error)")
            }
        }
    }
}
