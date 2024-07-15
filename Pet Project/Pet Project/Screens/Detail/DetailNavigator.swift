//
//  DetailNavigator.swift
//  Pet Project
//
//  Created by Sultan on 29/12/22.
//

import RxCocoa
import RxRelay

protocol IDetailNavigator {
    
}

struct DetailNavigator: IDetailNavigator {
    
    weak var viewController: IDetailViewController!
}


