import UIKit

class MyCoordinator: BaseCoordinator {
    override func start() {
        let vc = UINavigationController(rootViewController: UIViewController())
        self.navigationController = vc
    }
    
}
