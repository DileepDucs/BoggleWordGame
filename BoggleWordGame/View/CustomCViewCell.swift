//
//  CustomCViewCell.swift
//  BoggleWordGame
//
//  Created by Dileep Jaiswal on 12/03/20.
//  Copyright © 2020 Dileep Jaiswal. All rights reserved.
//

import UIKit


class CustomCViewCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var customLabel: UILabel!
    var item: (row: Int, column: Int, char: Character, cell: CustomCViewCell)?
    
    func configCell(row: Int, column: Int, char: Character) {
        item = (row: row, column: column, char: char, cell: self)
        customLabel.layer.masksToBounds = true
        customLabel.layer.cornerRadius = (self.frame.size.width) / 2
        customLabel.isUserInteractionEnabled = true
        self.layer.cornerRadius = 5
    }
}
