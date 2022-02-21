import UIKit

enum TabbarFlow {
    case home
    case search
    case my
}

class TabBarCoordinator: BaseCoordinator {
    private let homeCoordinator = HomeCoordinator(navigationController: UINavigationController())
    private let searchCoordinator = SearchCoordinator(navigationController: UINavigationController())
    private let myCoordinator = MyCoordinator(navigationController: UINavigationController())
    private let tabbarController = UITabBarController()
    
    override func start() {
        start(coordinator: homeCoordinator)
        start(coordinator: searchCoordinator)
        start(coordinator: myCoordinator)
        
        homeCoordinator.navigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "1.circle"), tag: 0)
        searchCoordinator.navigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "2.circle"), tag: 1)
        myCoordinator.navigationController.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "3.circle"), tag: 2)
        
        self.tabbarController.viewControllers = [homeCoordinator.navigationController, searchCoordinator.navigationController, myCoordinator.navigationController]
        
        tabbarController.tabBar.tintColor = .white
        tabbarController.tabBar.barTintColor = .black
        
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.pushViewController(tabbarController, animated: false)
    }
    
    func moveTo(flow: TabbarFlow) {
        switch flow {
        case .home:
            tabbarController.selectedIndex = 0
        case .search:
            tabbarController.selectedIndex = 1
        case .my:
            tabbarController.selectedIndex = 2
        }
    }
    
}

