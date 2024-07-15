//
//  BaseViewController.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

protocol BaseViewControllerProtocol: AnyObject {
    func setup()
    func setupSubviews()
    func setupConstraints()
    func setupBindings()
}

class BaseViewController: UIViewController, BaseViewControllerProtocol {
        
    let disposeBag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.clipsToBounds = true
        setup()
    }
    
    func commonInit() {
        
    }
    
    func setup() {
        setupSubviews()
        setupConstraints()
        setupBindings()
        applyLocalization()
    }
    
    func setupSubviews() {}
    
    func setupConstraints() {}
    
    func setupBindings() {}
    
    func applyLocalization() {
        
    }
}
