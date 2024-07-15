//
//  MainCollectionLayout.swift
//  Pet Project
//
//  Created by Sultan on 30/12/22.
//

import RxCocoa
import UIKit

class MainCollectionLayout: BaseCollectionViewLayout {
    
    override func setupLayout(for collectionView: UICollectionView) {
        super.setupLayout(for: collectionView)
        var lastFrame = CGRect.zero
        let x = CGFloat.zero
        let width = collectionView.frame.width / 3
        fullIteration { _ in
        } item: { [unowned self] indexPath in
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            let isNewLine = indexPath.row % 3 == 0 || indexPath.row == .zero
            let frame = CGRect(
                x: isNewLine ? 0 : lastFrame.maxX + x,
                y: isNewLine ? lastFrame.maxY : lastFrame.minY,
                width: width,
                height: width
            )
            lastFrame = frame
            attribute.frame = frame
            cellAttributes[indexPath] = attribute
            contentBounds = contentBounds.union(frame)
        }
        contentBounds = contentBounds.union(lastFrame)
        contentHeight.accept(contentBounds.height)
    }
}
