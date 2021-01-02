//
//  StringExtension.swift
//  BoggleWordGame
//
//  Created by Dileep Jaiswal on 29/12/20.
//  Copyright © 2020 Dileep Jaiswal. All rights reserved.
//

import UIKit

// MARK: String extension
extension String {
    func sharedPrefix(with other: String) -> String {
        return (self.isEmpty || other.isEmpty || self.first! != other.first!) ? "" :
            "\(self.first!)" + String(Array(self.dropFirst())).sharedPrefix(with: String(Array(other.dropFirst())))
    }
    
    func getCharAtIndex(_ index: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: index)]
    }
}
