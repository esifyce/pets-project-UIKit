//
//  UICollectionView+Extensions.swift
//  Pet Project
//
//  Created by Sultan on 30/12/22.
//

import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: T.identifier())
    }
    
    func registerHeader<T: UICollectionReusableView>(_ headerType: T.Type) {
        register(
            headerType,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.identifier()
        )
    }
    
    func getReuseCell<T: UICollectionViewCell>(indexPath: IndexPath, type: T.Type) -> T {
        dequeueReusableCell(withReuseIdentifier: T.identifier(), for: indexPath) as! T
    }
    
    func getCell<T: UICollectionViewCell>(indexPath: IndexPath, type: T.Type) -> T {
        cellForItem(at: indexPath) as! T
    }
    
    func getReuseHeader<T: UICollectionReusableView>(indexPath: IndexPath, type: T.Type) -> T {
        dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: T.identifier(),
            for: indexPath
        ) as! T
    }
    
    func getHeader<T: UICollectionReusableView>(indexPath: IndexPath, type: T.Type) -> T {
        supplementaryView(forElementKind: UICollectionView.elementKindSectionFooter, at: indexPath) as! T
    }
}
