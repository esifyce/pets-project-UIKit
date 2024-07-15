//
//  BaseCollectionViewLayout.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit
import RxCocoa

class BaseCollectionViewLayout: UICollectionViewLayout {
    
    var contentBounds = CGRect.zero
    var cellAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    var headerAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    
    enum Element {
        case cell
        case header
        case none
    }
    
    let contentHeight = PublishRelay<CGFloat>()
    
    var updateHeight: Driver<CGFloat> {
        contentHeight
            .distinctUntilChanged()
            .filter { [unowned self] _ in
                collectionView?.containsConstraint(attribute: .height) == true
            }.asDriver(onErrorDriveWith: .empty())
    }
    
    override func prepare() {
        super.prepare()
        guard let collectionView = collectionView else { return }
        setupLayout(for: collectionView)
    }
    
    func setupLayout(for collectionView: UICollectionView) {
        cellAttributes.removeAll()
        headerAttributes.removeAll()
        contentBounds = .init(origin: .zero, size: collectionView.bounds.size)
    }
    
    final func fullIteration(
        section: ((_ indexPath: IndexPath) -> ())?,
        item: ((_ indexPath: IndexPath) -> ())?
    ) {
        guard let collectionView = collectionView else { return }
        (0..<collectionView.numberOfSections).forEach { sectionIndex in
            section?(IndexPath(item: 0, section: sectionIndex))
            (0..<collectionView.numberOfItems(inSection: sectionIndex)).forEach { itemIndex in
                item?(IndexPath(item: itemIndex, section: sectionIndex))
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        contentBounds.size
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else {return false}
        return !newBounds.size.equalTo(collectionView.bounds.size)
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        cellAttributes[indexPath]
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var vidibleAttributes = [UICollectionViewLayoutAttributes]()
        headerAttributes.forEach { indexPath, attribute in
            if attribute.frame.intersects(rect) {
                vidibleAttributes.append(attribute)
            }
        }
        cellAttributes.forEach { indexPath, attribute in
            if attribute.frame.intersects(rect) {
                vidibleAttributes.append(attribute)
            }
        }
        return vidibleAttributes
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        headerAttributes[indexPath]
    }

    final func computedTextSize(
        text: String?,
        font: UIFont,
        cellWidth: CGFloat = .greatestFiniteMagnitude,
        cellHeight: CGFloat = .greatestFiniteMagnitude
    ) -> CGSize {
        let constraintRect = CGSize(width: cellWidth, height: cellHeight)
        let boundingBox = (text ?? "").boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )
        return .init(width: ceil(boundingBox.width), height: ceil(boundingBox.height))
    }
    
    final func isLastElementInSection(with indexPath: IndexPath) -> Bool {
        guard
            let collectionView = collectionView,
            indexPath.section < collectionView.numberOfSections
        else { return false }
        return indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1
    }
}

private extension UICollectionView {
    func containsConstraint(attribute: NSLayoutConstraint.Attribute) -> Bool {
        constraints.first(where: { $0.firstAttribute == attribute }) != nil
    }
}
