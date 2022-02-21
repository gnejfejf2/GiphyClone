import UIKit

class SearchCoordinator: BaseCoordinator {
    override func start() {
        let viewController = SearchViewController()
        let viewModel = SearchViewModel()
        viewController.viewModel = viewModel
        viewModel.coordinator = self
        
        
        let vc = UINavigationController(rootViewController: viewController)
        self.navigationController = vc
    }
    
}
