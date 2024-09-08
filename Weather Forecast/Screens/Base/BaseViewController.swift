import UIKit

class BaseViewController: UIViewController {
    
    var baseViewModel: BaseViewModel? {
        didSet {
            setupBaseBindings()
        }
    }
    
    func setupBaseBindings() {
        baseViewModel?.error.bind { [weak self] value in
            guard let value else {
                return
            }
            
            self?.showAlert(title: "Ошибка!",
                            message: value.localizedDescription,
                            firstActionTitle: "Повторить",
                            secondActionTitle: "Продолжить",
                            firstCompletion: self?.baseViewModel?.updateCompletion,
                            secondCompletion: {})
        }
        
        baseViewModel?.loading.bind { value in
            guard let value else {
                return
            }
            
            value ? SimplyLoader.start() : SimplyLoader.stop()
        }
    }
}
