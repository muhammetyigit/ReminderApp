// TodoCollectionViewCell.swift
// ReminderApp

import UIKit

class TodoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    var isChecked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.borderColor = UIColor.white.cgColor
        updateCheckButtonImage()
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        isChecked.toggle()
        updateCheckButtonImage()
    }
    
    private func updateCheckButtonImage() {
        UIView.transition(with: checkButton, duration: 0.3, options: .transitionCrossDissolve, animations: {
            if self.isChecked {
                self.checkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            } else {
                self.checkButton.setImage(UIImage(systemName: "circle"), for: .normal)
            }
        }, completion: nil)
    }
}
