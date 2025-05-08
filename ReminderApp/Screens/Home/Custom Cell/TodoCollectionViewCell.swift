//
//  TodoCollectionViewCell.swift
//  ReminderApp
//
//  Created by Muhammet Yiğit on 8.05.2025.
//

import UIKit

class TodoCollectionViewCell: UICollectionViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
    }
    
}
