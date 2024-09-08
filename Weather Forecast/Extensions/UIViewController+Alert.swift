import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, firstActionTitle: String?, secondActionTitle: String? = nil, firstCompletion: (() -> Void)?, secondCompletion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let firstAction = UIAlertAction(title: firstActionTitle ?? "OK", style: .default) { (action) in
            firstCompletion?()
        }
        alertController.addAction(firstAction)
        
        if let secondActionTitle = secondActionTitle {
            let secondAction = UIAlertAction(title: secondActionTitle, style: .default) { (action) in
                secondCompletion?()
            }
            alertController.addAction(secondAction)
        }
        
        self.present(alertController, animated: true)
    }
}
