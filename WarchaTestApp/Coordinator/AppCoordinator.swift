
import UIKit

class AppCoordinator: BaseCoordinator {
    var window : UIWindow?
    
    override func start() {
        window?.makeKeyAndVisible()
        tabBar()
    }
    
    private func tabBar() {
        removeChildCoordinators()
        
        let coordinator = TabBarCoordinator(navigationController: navigationController)
        start(coordinator: coordinator)
        
        window?.rootViewController = coordinator.navigationController
    }
    
}
