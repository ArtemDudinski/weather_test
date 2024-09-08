import UIKit
import SnapKit

class TabBarController: UITabBarController {
    
    private lazy var searchButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.init(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(searchAction), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.tintColor = .black
        button.layer.cornerRadius = 36
        button.isEnabled = true
        return button
    }()
    
    private let emptyViewController = UIViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupViewControllers()
        setupSearchButton()
    }
}

// MARK: - Setup
private extension TabBarController {
    func setup() {
        tabBar.isTranslucent = true
        tabBar.barTintColor = .black
        tabBar.backgroundColor = .black
        tabBar.tintColor = .systemBlue
        
        delegate = self
    }
    
    func setupViewControllers() {
        let mainViewModel = MainViewModel()
        let mainViewContrller = MainViewController()
        mainViewContrller.viewModel = mainViewModel
        let mainNavigationController = UINavigationController.configureNavigationControllerForSuperControllers(with: mainViewContrller)
        mainNavigationController.tabBarItem = TabBarItemFactory.mainItem
        mainNavigationController.setNavigationBarHidden(false, animated: true)
        
        let forecastViewModel = ForecastViewModel()
        let forecastViewController = ForecastViewController()
        forecastViewController.viewModel = forecastViewModel
        let forecasetNavigationController = UINavigationController.configureNavigationControllerForSuperControllers(with: forecastViewController)
        forecasetNavigationController.tabBarItem = TabBarItemFactory.forecsstItem
        forecasetNavigationController.setNavigationBarHidden(false, animated: true)
        
        
        viewControllers = [ mainNavigationController, emptyViewController, forecasetNavigationController  ]
    }
    
    func setupSearchButton() {
        tabBar.viewWithTag(0)?.addSubview(searchButton)
        
        searchButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40.scalable)
            $0.size.equalTo(72)
        }

        view.layoutIfNeeded()
    }
}

// MARK: - Actions
private extension TabBarController {
    @objc
    func searchAction() {
        let findViewModel = FindViewModel()
        let findViewController = FindViewController()
        findViewController.viewModel = findViewModel
        let findNavigationController = UINavigationController.configureNavigationControllerForSuperControllers(with: findViewController)
        findNavigationController.modalPresentationStyle = .fullScreen
        findNavigationController.modalTransitionStyle = .coverVertical
        present(findNavigationController, animated: true)
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return viewController != emptyViewController
    }
}
