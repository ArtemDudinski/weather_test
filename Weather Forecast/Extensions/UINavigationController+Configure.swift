import UIKit

extension UINavigationController {
    static func configureNavigationControllerForSuperControllers(with rootController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootController)
        let navigationBar = navigationController.navigationBar
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)
        ]
        appearance.backgroundColor = .black
        appearance.shadowColor = .clear
        
        navigationBar.backgroundColor = .black
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.semanticContentAttribute = .forceLeftToRight
        
        navigationController.navigationBar.tintColor = UIColor.systemBlue
        
        return navigationController
    }
}
