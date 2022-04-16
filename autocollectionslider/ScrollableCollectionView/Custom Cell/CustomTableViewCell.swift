//
//  CustomTableViewCell.swift
//  ScrollableCollectionView
//
//  Created by Sabir Myrzaev on 17/4/22.
//

import UIKit

let collectionCellIdentifier = "CustomCollectionCell"

class CustomTableViewCell: UITableViewCell {
    
    var arrayOfCollection = [String]()
    
    @IBOutlet weak var pageController: UIPageControl? {
        didSet {
            pageController?.tintColor = .darkGray
            pageController?.currentPageIndicatorTintColor = .red
        }
    }
    
    @IBOutlet open weak var collectionView: UICollectionView? {
        didSet {
            collectionView?.register(UINib(nibName: collectionCellIdentifier, bundle: nil), forCellWithReuseIdentifier: collectionCellIdentifier)
            collectionView?.dataSource = self
            collectionView?.delegate = self
            collectionView?.isPagingEnabled = true
            collectionView?.isScrollEnabled = true
            collectionView?.layer.cornerRadius = 20
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        self.layer.cornerRadius = 10
    }
    
    func configureCell(arr : [String]) {
        arrayOfCollection = arr
        pageController!.numberOfPages = arrayOfCollection.count
        setTimer()
    }
}

// MARK: Functions to Automatically Scroll Collection View Cell / PageView Controller
extension CustomTableViewCell {
    
    func setTimer() {
        let _ = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToNextCell() {
        
        let cellSize = CGSize(width: collectionView!.frame.size.width, height: collectionView!.frame.size.height)
        let contentOffset = collectionView!.contentOffset;
        if collectionView!.contentSize.width <= collectionView!.contentOffset.x + cellSize.width
        {
            collectionView!.scrollRectToVisible(CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);
        }
        else
        {
            collectionView!.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true);
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectionView!.contentOffset, size: collectionView!.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = collectionView!.indexPathForItem(at: visiblePoint) {
            pageController!.currentPage = visibleIndexPath.row
        }
    }
}

// MARK: CollectionView Extensions

extension CustomTableViewCell : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as? CustomCollectionCell {
            cell.imgCollection.image = UIImage.init(named: arrayOfCollection[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
}

