//
//  WordListViewModel.swift
//  BoggleWordGame
//
//  Created by Dileep Jaiswal on 02/01/21.
//  Copyright © 2021 Dileep Jaiswal. All rights reserved.
//

import UIKit

class AllMoviesViewModel {
    let apiService: APIServiceProtocol

    private var items: [ModelData] = [ModelData]()

    var numberOfItems: Int {
        return items.count
    }
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    var reloadTableViewClosure: (()->())?
    var updateLoadingStatus: (()->())?
    var showAlertClosure: (()->())?

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        initFetch()
    }

    func initFetch() {
        self.isLoading = true
        apiService.fetchAllWords(fileName: "words") { [weak self] (success, movies, error) in
            self?.isLoading = false
            if let error = error {
                self?.alertMessage = error.rawValue
            } else {
                self?.processFetchedWord(list: movies)
            }
        }
    }
    
    private func processFetchedWord(list: [ModelData]) {
        items = list
    }
    
    func wordModel(index: Int) -> ModelData {
        return items[index]
    }
    
    func title(index: Int) -> String {
        let wordModel = self.wordModel(index: index)
        return wordModel.title
    }
    
    func subtitle(index: Int) -> String {
        let wordModel = self.wordModel(index: index)
        let subtitle = wordModel.list.joined(separator: ", ")
        return subtitle
    }
    
    func wordList(index: Int) -> [String] {
        let wordModel = self.wordModel(index: index)
        return wordModel.list
    }
}
