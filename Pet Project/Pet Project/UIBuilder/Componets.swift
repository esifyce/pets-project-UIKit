//
//  Componets.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit

struct Components {
    
    static func any<Object>(_ object: Object.Type) -> UIBuilder<Object> {
        return UIBuilder()
    }
    static func any<Object>(_ object: Object) -> UIBuilder<Object> {
        return UIBuilder(object)
    }
    
    struct View {
        static var `default`: UIBuilder<UIView> {
            return UIBuilder()
        }
        static var base: UIBuilder<BaseView> {
            return UIBuilder()
        }
    }
    
    // MARK: - Label
    
    struct Label {
        static var `default`: UIBuilder<UILabel> {
            return UIBuilder()
        }
        static var base: UIBuilder<BaseLabel> {
            return UIBuilder()
        }
    }
    
    // MARK: - Button
    
    struct Button {
        static var `default`: UIBuilder<UIButton> {
            return UIBuilder()
        }
        static var base: UIBuilder<BaseButton> {
            return UIBuilder()
        }
    }
    
    // MARK: - ImageView
    
    struct ImageView {
        static var `default`: UIBuilder<UIImageView> {
            return UIBuilder()
        }
        static var base: UIBuilder<BaseImageView> {
            return UIBuilder()
        }
    }
    
    // MARK: - TextField
    
    struct TextField {
        static var `default`: UIBuilder<UITextField> {
            return UIBuilder()
        }
    }
    
    // MARK: - StackView
    
    struct StackView {
        static var `default`: UIBuilder<UIStackView> {
            return UIBuilder()
        }
    }
    
    // MARK: - ScrollView
    
    struct ScrollView {
        static var `default`: UIBuilder<UIScrollView> {
            return UIBuilder()
        }
        static var base: UIBuilder<BaseScrollView> {
            return UIBuilder()
        }
    }
    
    // MARK: - CollectionView
    
    static func CollectionView(
        layout: UICollectionViewLayout = UICollectionViewFlowLayout()
    ) -> UIBuilder<UICollectionView> {
        UIBuilder(UICollectionView(frame: .zero, collectionViewLayout: layout))
    }
}
