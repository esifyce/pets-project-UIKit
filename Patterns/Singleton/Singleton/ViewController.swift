//
//  ViewController.swift
//  Singleton
//
//  Created by Sabir Myrzaev on 18.06.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let safe = Safe.shared
        print(safe.money)
    }


}

