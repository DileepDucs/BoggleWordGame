//
//  ListViewController.swift
//  BoggleWordGame
//
//  Created by Dileep Jaiswal on 28/12/20.
//  Copyright © 2020 Dileep Jaiswal. All rights reserved.
//

import UIKit

enum MatrixDirection {
    case leftToRight
    case topToBottom
    case leftTopToRightBottomCorner
    case leftBottomToRightTopCorner
    case rightToBottom
}

enum Level: String {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}

class ListViewController: UIViewController {
    var viewModel: AllMoviesViewModel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        initViewModel()
        
    }
    
    private func initViewModel() {
        viewModel = AllMoviesViewModel()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let item = viewModel.wordModel(index: indexPath.row)
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = viewModel.subtitle(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openBoggleGameWith(index: indexPath.row)
    }
    
    func getMatrixDimensionWith(level: String) -> Int {
        if let selectedLevel = Level(rawValue: level) {
            switch selectedLevel {
            case .easy:
                return 4
            case .medium:
                return 5
            case .hard:
                return 6
            }
        }
        return 5
    }
    
    func openBoggleGameWith(index: Int) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BoggleViewController") as! BoggleViewController
        nextViewController.listOfItem = viewModel.wordList(index: index)
        let title = viewModel.title(index: index)
        nextViewController.level = title
        let count = getMatrixDimensionWith(level: title)
        nextViewController.matrix = Grid(rows: count, columns: count)
        nextViewController.numberOfItemsPerRow = count
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}

