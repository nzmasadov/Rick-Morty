//
//  MainNavigationController.swift
//  ABB_TestCase_nzmasadov
//
//  Created by Test Test on 27.10.22.
//

import Foundation
import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc = HomeViewController()
        
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = true
        navigationBar.barStyle = .default
        navigationBar.tintColor = .label
        
        viewControllers = [vc]
    }
}
