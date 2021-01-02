//
//  BoggleViewController.swift
//  BoggleWordGame
//
//  Created by Dileep Jaiswal on 27/03/20.
//  Copyright © 2020 Dileep Jaiswal. All rights reserved.
//

import UIKit

class BoggleViewController: UIViewController {
    
    @IBOutlet weak var customCV: UICollectionView!
    private let spacing:CGFloat = 5.0
    var panRec: UIPanGestureRecognizer?
    var matrix = Grid(rows: 3, columns: 3)
    var numberOfItemsPerRow:Int = 3
    var counter: Int = -1
    var listOfItem = [String]()
    var color: UIColor?
    var answeredItem = [String]()
    var level: String = ""
    var errorLabel: UILabel?
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var hintLable: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = level.uppercased()
        DispatchQueue.main.async {
            self.hintLable.text = self.listOfItem.joined(separator: "  ")
        }
        color = self.getRandomColor()
        customCV.delegate = self
        customCV.dataSource = self
        customCV.isUserInteractionEnabled = true
        //matrix.setCharacterInMatrix()
        matrix.setDefaultsForDummyList()
        for word in listOfItem {
            var isWordCreated = true
            var count = 0
            repeat {
                let cordinateWithIndex = matrix.getCoordinateFromEmptyList()
                if let cordinate = cordinateWithIndex.0 {
                    isWordCreated = matrix.getListArayWithCoordinate(row: cordinate.row, column: cordinate.column, word: word, direction: matrix.getRandomDirection())
                    if isWordCreated {
                        //matrix.fullList.append((cordinate.row, cordinate.column))
                        matrix.emptyList.remove(at: cordinateWithIndex.index)
                    } else {
                        count = count + 1
                        if count == 30 {
                            print(count)
                            isWordCreated = true
                        }
                    }
                    print(isWordCreated)
                }
            } while (isWordCreated == false)
        }
        matrix.setCharacterInMatrix()
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        self.customCV?.collectionViewLayout = layout
        
        
        panRec = UIPanGestureRecognizer(target: self, action: #selector(BoggleViewController.handlePanGesture(gesture:)))
        panRec?.delegate = self
        customCV.addGestureRecognizer(panRec!)
        matrix.printRandomCharMatrix()
        self.setErrorLabel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let width = getMatrixWidthWith(level: level)
        let origin = (UIScreen.main.bounds.width - width) / 2
        customCV.frame = CGRect(x: origin, y: answerLabel.frame.origin.y + 50 , width: width, height: width)
    }
    
    func setErrorLabel() {
        
        errorLabel = UILabel(frame: CGRect(x: (self.view.frame.width - 120) / 2, y: 400 , width: 220, height: 40))
        errorLabel?.alpha = 0.0
        errorLabel?.textColor = .white
        errorLabel?.layer.cornerRadius = 5.0
        errorLabel?.clipsToBounds = true
        errorLabel?.backgroundColor = UIColor.red
        errorLabel?.textAlignment = .center
        errorLabel?.bringSubviewToFront(customCV)
        self.view.addSubview(errorLabel!)
    }
    
    func getMatrixWidthWith(level: String) -> CGFloat {
        if let selectedLevel = Level(rawValue: level) {
            switch selectedLevel {
            case .easy:
                return 320
            case .medium:
                return UIScreen.main.bounds.width
            case .hard:
                return UIScreen.main.bounds.width
            }
        }
        return UIScreen.main.bounds.width
    }
    
    func getRandomColor() -> UIColor {
        return UIColor.random
    }
    
    
    
    @objc func handlePanGesture(gesture: UIPanGestureRecognizer) {
        let touch = gesture.location(in: customCV)
        if let indexPath = customCV.indexPathForItem(at: touch) {
            if let cell: CustomCViewCell = customCV.cellForItem(at: indexPath) as? CustomCViewCell {
                let coordinate = gesture.location(in: cell.backView)
                let center = cell.customLabel.center
                let radius = (cell.customLabel.frame.width) / 2
                let formula = (((coordinate.x - center.x) * (coordinate.x - center.x)) +
                            ((coordinate.y - center.y) * (coordinate.y - center.y)))
                let distance = sqrt(formula)
                if radius >= distance {
                    cell.backView.backgroundColor = self.color
                    if let item = cell.item {
                        if let object = matrix.runningWords.filter({ $0 == item }).first {
                            //print(object.char)
                        } else {
                            matrix.runningWords.append(item)
                        }
                    }
                }
            }
        }
    }

}

extension BoggleViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacingBetweenCells:CGFloat = 5
        let totalSpacing = (2 * self.spacing) + ((CGFloat(numberOfItemsPerRow) - 1) * spacingBetweenCells) //Amount of total spacing in a row
        if let collection = self.customCV {
            let width = (collection.bounds.width - totalSpacing)/CGFloat(numberOfItemsPerRow)
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}

extension BoggleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return matrix.count()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as? CustomCViewCell
        let item = indexPath.item
        let column: Int = item % numberOfItemsPerRow
        if column == 0 {
            counter = counter + 1
        }
        let row = counter
        let char = matrix[row, column]
        cell?.customLabel.text = String(char)
        cell?.configCell(row: row, column: column, char: char)
        return cell!
    }
}

extension BoggleViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        matrix.runningWords.removeAll()
        color = getRandomColor()
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive press: UIPress) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if (gestureRecognizer.state == .ended) {
            let string = matrix.getRunningWordsFormCharacter()
            if listOfItem.contains(string) {
                if !answeredItem.contains(string) {
                    answeredItem.append(string)
                    DispatchQueue.main.async {
                        self.answerLabel.text = self.answeredItem.joined(separator: "  ")
                    }
                }
            }else {
                var cellViewTop: CustomCViewCell?
                for item in matrix.runningWords {
                    DispatchQueue.main.async {
                        item.cell.backView.backgroundColor = UIColor(hexString: "EBFFF1")
                        cellViewTop = item.cell
                    }
                }
                DispatchQueue.main.async {
                    self.errorViewAnimation(originY: cellViewTop?.frame.origin.y ?? 400, string: string)
                }
                
            }
        }
        return true
    }
    
    func errorViewAnimation(originY: CGFloat, string: String) {
        self.errorLabel?.text = "Wrong word: \(string)"
        self.errorLabel?.center.y = 200
        self.errorLabel?.alpha = 1.0
        UIView.animate(withDuration: 2, delay: 0.0,
                       options: [.curveEaseOut , .beginFromCurrentState], animations: {
          self.errorLabel?.center.y = 150
        }, completion: { finished in
            self.errorLabel?.alpha = 0.0
        })
    }
}

