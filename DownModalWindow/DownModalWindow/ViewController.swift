//
//  ViewController.swift
//  DownModalWindow
//
//  Created by Sabir Myrzaev on 23/5/22.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Views
    
    private var button1: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button1", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(bottomModalSheet), for: .touchUpInside)
        return button
    }()
    
    private var button2: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button2", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(bottomModalSheet), for: .touchUpInside)
        return button
    }()
    
    private var button3: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Button3", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(bottomModalSheet), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        congigureUI()
        
    }
    
    // MARK: - Selectors
    
    @objc func bottomModalSheet() {
        let vc = CustomModalViewController()
        vc.modalPresentationStyle = .overCurrentContext
        self.present(vc, animated: false)
    }
    
    // MARK: - Helpers
    
    private func congigureUI() {
        view.backgroundColor = .white
        view.addSubview(button1)
        view.addSubview(button2)
        view.addSubview(button3)
        
        setConstraints()
    }
    
    private func setConstraints() {
        button2.center(inView: view)
        button1.centerX(inView: view)
        button3.centerX(inView: view)
        button1.apply(bottom: button2.topAnchor, marginBottom: 20)
        button3.apply(top: button2.bottomAnchor, marginTop: 20)
        
    }


}

