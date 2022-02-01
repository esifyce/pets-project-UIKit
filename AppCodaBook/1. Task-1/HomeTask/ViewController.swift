//
//  ViewController.swift
//  HomeTask
//
//  Created by Sabir Myrzaev on 18.09.2021.
//

import UIKit

class ViewController: UIViewController {

    // Actions
    @IBAction func showMessage(sender: UIButton) {
        let selectedButton = sender
        
        if let wordToLookup = selectedButton.titleLabel?.text {
            
            // alert
            let alertController = UIAlertController(title: wordToLookup,
                                                    message: wordToLookup,
                                                    preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: wordToLookup,
                                                    style: UIAlertAction.Style.default,
                                                    handler: nil))
            present(alertController, animated: true, completion: nil)
            
            print(wordToLookup)
        }
    }
    
    // LifeCycle VC
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

