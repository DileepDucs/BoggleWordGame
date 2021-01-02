//
//  Matrix.swift
//  BoggleWordGame
//
//  Created by Dileep Jaiswal on 28/03/20.
//  Copyright © 2020 Dileep Jaiswal. All rights reserved.
//

import Foundation

struct Grid {
    let rows: Int, columns: Int
    var charList: [Character]
    var emptyList: [(row: Int, column: Int)]
    var fullList: [(row: Int, column: Int)]
    var directionArray: [MatrixDirection]
    var runningWords: [(row: Int, column: Int, char: Character, cell: CustomCViewCell)]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        charList = Array(repeating: "?", count: rows * columns)
        directionArray = [/*.leftToRight, .topToBottom,*/ .leftTopToRightBottomCorner, .leftBottomToRightTopCorner, .rightToBottom]
        emptyList = Array()
        fullList = Array()
        runningWords = Array()
    }
    
    mutating func setDefaultsForDummyList() {
        for row in 0..<rows {
            for column in 0..<columns {
                emptyList.append((row, column))
            }
        }
    }
    
    mutating func setValueForMatrix(char: Character) {
        let index = getRandomNumberFrom(start: 0, end: emptyList.count)
        let coordinate = emptyList[index]
        emptyList.remove(at: index)
        fullList.append(coordinate)
        self[coordinate.row, coordinate.column] = char
    }
   
    func getRunningWordsFormCharacter() -> String {
        let array = self.runningWords.map { $0.char}
        return String(array)
    }
    
    func getRandomDirection() -> MatrixDirection {
        let index = getRandomNumberFrom(start: 0, end: 3)
        return directionArray[index]
    }
    
    mutating func getListArayWithCoordinate(row: Int, column: Int, word: String, direction: MatrixDirection) -> Bool {
        var array =  [Character]()
        runningWords.removeAll()
        var coordinateList = [(row: Int, column: Int)]()
        switch direction {
        case .leftToRight:
            let length = column + word.count
            if length > columns {
                return false
            }
            var count = 0
            for index in column..<length {
                if self[row, index] == "?" {
                    array.append(word.getCharAtIndex(count))
                    coordinateList.append((row: row, column: index))
                    count += 1
                }
            }
            if count == word.count {
                count = 0
                for index in column..<(column + word.count) {
                    self[row, index] = array[count]
                    self.fullList.append((row, column))
                    count += 1
                }
                return true
            }
            return false
        case .leftTopToRightBottomCorner:
            var count = 0
            var p = row
            if (row + word.count > columns) || (column + word.count > columns) {
                return false
            }
            for index in column..<(column + word.count) {
                if self[p, index] == "?" {
                    p = p + 1
                    array.append(word.getCharAtIndex(count))
                    count += 1
                }
            }
            if count == word.count {
                count = 0
                p = row
                for index in column..<(column + word.count) {
                    self[p, index] = array[count]
                    p += 1
                    count += 1
                }
                return true
            }
            return false
        case .leftBottomToRightTopCorner:
            var count = 0
            var p = row
            if (row  + 1 - word.count < 0)  || (column + word.count > columns){
                return false
            }
            for index in column..<(column + word.count) {
                if self[p, index] == "?" {
                    p = p - 1
                    array.append(word.getCharAtIndex(count))
                    count += 1
                }
            }
            if count == word.count {
                count = 0
                p = row
                for index in column..<(column + word.count) {
                    self[p, index] = array[count]
                    p -= 1
                    count += 1
                }
                return true
            }
            return false
        case .topToBottom:
            let length = row + word.count
            if length > rows {
                return false
            }
            var count = 0
            for index in row..<length {
                if self[index, column] == "?" {
                    array.append(word.getCharAtIndex(count))
                    count += 1
                }
            }
            if count == word.count {
                count = 0
                for index in row..<(row + word.count) {
                    self[index, column] = array[count]
                    count += 1
                }
                return true
            }
             return false
        case .rightToBottom:
            var runRow = row
            var runColumn = column
            var count = 0
            for index in 0..<word.count {
                print("runRow:\(runRow), runColumn:\(runColumn)")
                if ((runColumn - 1) < 0) {
                    break
                }
                if runColumn < columns && self[runRow, runColumn] == "?" {
                    array.append(word.getCharAtIndex(index))
                    coordinateList.append((row: runRow, column: runColumn))
                    runColumn += 1
                    count += 1
                } else if runRow + 1 < rows && self[runRow + 1, runColumn - 1] == "?" {
                    array.append(word.getCharAtIndex(index))
                    coordinateList.append((row: runRow + 1, column: runColumn - 1))
                    runRow += 1
                    count += 1
                }
            }
            if count == word.count {
                count = 0
                for coordinate in coordinateList {
                    self[coordinate.row, coordinate.column] = array[count]
                    count += 1
                }
                return true
            }
            return false
        }
    }

    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }

    func printRandomCharMatrix() {
        for row in 0..<rows {
            for column in 0..<columns {
                print("", self[row, column], separator: " ", terminator:"")
            }
            print("\n")
        }
    }
    
    mutating func setCharacterInMatrix() {
        for row in 0..<rows {
            for column in 0..<columns {
                if self[row, column] == "?" {
                    self[row, column] = randomizeCharacter()
                }
            }
        }
    }
    
    func isValidCordinate(row: Int, column: Int) -> Bool {
        if row < 0 || row >= rows || column < 0 || column >= columns {
            return false
        }
        return true
    }
    
    func getNextCoordinateFor(row: Int, column: Int) -> (Int, Int) {
        _ = isValidCordinate(row: row, column: column)
        return (rows, columns)
    }
    
    func getRandomNumberFrom(start: Int, end: Int) -> Int{
        return Int.random(in: start ..< end)
    }
    
    func getCoordinateFromEmptyList() -> ((row: Int, column: Int)?, index: Int) {
        if self.emptyList.count < 1 {
            return (nil, index: -1)
        }
        let index = getRandomNumberFrom(start: 0, end: self.emptyList.count)
        let coordinate = self.emptyList[index]
        return (coordinate, index: index)
    }
    
    func getCoordinateFromFullList() -> (row: Int, column: Int)? {
        if self.fullList.count < 1 {
            return nil
        }
        let index = getRandomNumberFrom(start: 0, end: self.fullList.count)
        let coordinate = self.fullList[index]
        return coordinate
    }

    func randomizeCharacter() -> Character {
        let alphabet: [Character] = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
        let rand = Int(arc4random_uniform(26))
        return alphabet[rand]
    }
    
    func count() -> Int{
        return charList.count
    }

    subscript(row: Int, column: Int) -> Character {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return charList[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            charList[(row * columns) + column] = newValue
        }
    }
}
