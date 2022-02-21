import UIKit

class HomeCoordinator: BaseCoordinator {
    override func start() {
        let vc = UINavigationController(rootViewController: UIViewController())
        
        self.navigationController = vc
    }
    
}
