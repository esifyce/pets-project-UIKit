//
//  Bundle + Extension.swift
//  SketchFrontProject
//
//  Created by Sabir Myrzaev on 07.06.2021.
//

import Foundation
import UIKit

extension Bundle {
    func decode<T: Decodable>(_ type: T.Type, from file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else { fatalError("failed to lacate \(file) from bundle")}
        
        guard let data = try? Data(contentsOf: url) else { fatalError("failed to lacate \(file) from bundle")}
        
        let decoder = JSONDecoder()
        
        guard  let loaded = try? decoder.decode(T.self, from: data) else {
            fatalError("failed to lacate \(file) from bundle")
        }
        return loaded
    }
}
