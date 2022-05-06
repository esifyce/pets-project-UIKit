//
//  FlowLayout.swift
//  MarineInhabitants
//
//  Created by Sabir Myrzaev on 29/4/22.
//

import UIKit

class FlowLayout: UICollectionViewFlowLayout {
    
    let screenSize = UIScreen.main.bounds
    var cellsPerRow: Int
    let numberOfItems: Int
    var _itemSize: CGSize {
        .init(
            width: height,
            height: height
        )
    }
    var height: CGFloat {
        (screenSize.width - 40 - CGFloat(numberOfItems - 1) * minimumInteritemSpacing) / CGFloat(numberOfItems)
    }
    

    required init(cellsPerRow: Int = 1, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero, numberOfItems: Int = 4) {
        self.cellsPerRow = cellsPerRow
        self.numberOfItems = numberOfItems

        super.init()

        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.minimumLineSpacing = minimumLineSpacing
        self.sectionInset = sectionInset
        self.itemSize = _itemSize
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        super.layoutAttributesForItem(at: indexPath)
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        super.layoutAttributesForElements(in: rect)
    }

}
