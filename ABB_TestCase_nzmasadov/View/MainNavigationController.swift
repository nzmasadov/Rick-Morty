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
