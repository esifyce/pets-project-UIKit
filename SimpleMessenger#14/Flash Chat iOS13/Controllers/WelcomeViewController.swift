//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        // скрывает navigationBar во всех контрелларах
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        // показывает navigationBar в других контроллерах после перехода с кнопки и т.д
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        // анимация лого FlashChat
        var charIndex = 0.0
        let titleText = K.appName
        titleLabel.text = ""
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { (Timer) in
                self.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
    @IBAction func welcomeRegisterUIButton(_ sender: UIButton) {
       
    }
    
    @IBAction func welcomeLoginUIButton(_ sender: UIButton) {
       
    }
    
}
