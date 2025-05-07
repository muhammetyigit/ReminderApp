//
//  HomeViewController.swift
//  ReminderApp
//
//  Created by Muhammet Yiğit on 7.05.2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - UI Elements
    @IBOutlet weak var dateCollectionView: UICollectionView!
   
    
    // MARK: - Properties
    var date = ["1 Ocak", "2 Ocak", "3 Ocak", "4 Ocak", "5 Ocak", "6 Ocak", "7 Ocak", "8 Ocak", "9 Ocak", "10 Ocak"]
    var selectedIndexPath: IndexPath?
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateCollectionView.delegate = self
        dateCollectionView.dataSource = self
        dateCollectionView.showsHorizontalScrollIndicator = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewDidScroll(dateCollectionView)
    }
    
    // MARK: - Functions
    
    // MARK: - Actions
}

// MARK: - UICollectionViewDelegate & UICollectionViewDataSource & UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return date.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = dateCollectionView.dequeueReusableCell(withReuseIdentifier: "date", for: indexPath) as? DateCollectionViewCell else { return UICollectionViewCell() }
        item.dateLabel.text = date[indexPath.row]
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 55)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let centerX = dateCollectionView.contentOffset.x + dateCollectionView.bounds.size.width / 2
        
        for cell in dateCollectionView.visibleCells {
            guard let dateCell = cell as? DateCollectionViewCell else { continue }
            
            let cellCenterX = cell.center.x
            let distance = abs(cellCenterX - centerX)
            let maxDistance = dateCollectionView.bounds.size.width / 2
            
            let ratio = min(distance / maxDistance, 1.0)
            
            let fontSize = 17 - (8 * ratio)
            let alpha = max(1 - ratio, 0.3)
            
            UIView.animate(withDuration: 0.2) {
                dateCell.dateLabel.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
                dateCell.dateLabel.alpha = alpha
            }
        }
    }
}
