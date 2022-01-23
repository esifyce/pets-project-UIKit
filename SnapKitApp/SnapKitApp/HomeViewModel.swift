//
//  HomeViewModel.swift
//  SnapKitApp
//
//  Created by Sabir Myrzaev on 24.01.2022.
// 

import UIKit

class HomeViewModel {
    
    private let imageNames = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    private let titles = ["Nature", "Beaches", "Outdoor", "Playground", "Fun"]
    
    // MARK: - CollectionViewDataSource
    func numberOfRows() -> Int {
        return 20
    }
    
    func modelFor(row: Int) -> CarousalCollectionViewCell.Model {
        let randomImages = imageNames.random(3)
        let title = titles.randomElement()
        let like = [true, false].randomElement() ?? false
        let carouselModel = CarouselView.Model(images: randomImages)
        let model = CarousalCollectionViewCell.Model(title: title, description: "This is demo description", liked: like, model: carouselModel)
        return model
    }
}

extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
    
    func random(_ n: Int) -> [UIImage] {
        let names = choose(n)
        let images = names.map { return UIImage(named: $0 as! String)!}
        return images
    }
}
