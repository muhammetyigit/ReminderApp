//
//  TodoCollectionViewCell.swift
//  ReminderApp
//
//  Created by Muhammet Yiğit on 7.05.2025.
//

import UIKit

protocol TodoButtonInput {
    func congifureButton(cell: TodoCollectionViewCell)
    func deleteTask(cell: TodoCollectionViewCell)
}

class TodoCollectionViewCell: UICollectionViewCell {
    
    var delegate: TodoButtonInput?
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 0.8
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        self.isUserInteractionEnabled = true
        self.contentView.isUserInteractionEnabled = true
        
        deleteButton.isHidden = true
        deleteButton.setImage(UIImage(systemName: "trash"), for: .normal)
    }
    
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        delegate?.congifureButton(cell: self)
    }
    
    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        if let delegate = delegate as? HomeViewController {
            delegate.deleteTask(cell: self)
        }
    }
    
    func buttonConfigure(isCheck: Bool) {
        let imageName = isCheck ? "checkmark.circle.fill" : "circle"
        let image = UIImage(systemName: imageName)
        checkButton.setImage(image, for: .normal)
    }
    
    func setDeleteButtonVisible(_ visible: Bool) {
        deleteButton.isHidden = !visible
    }
}
