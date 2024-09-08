import UIKit

class MainViewController: BaseViewController {
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.scalable, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 32.scalable, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15.scalable, weight: .regular)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var updateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12.scalable, weight: .light)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    
    var viewModel: MainViewModel? {
        didSet {
            baseViewModel = viewModel
            setupBindings()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

// MARK: - Setup
private extension MainViewController {
    func setup() {
        view.backgroundColor = .white
        
        viewModel?.requestData()
        

        let barButtonItem = UIBarButtonItem(image: .init(systemName: "arrow.clockwise"), style: .done, target: self, action: #selector(refreshLocation))
        
        navigationItem.rightBarButtonItems = [ barButtonItem ]
        navigationItem.title = "Main"
        
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16.scalable)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(temperatureLabel)
        temperatureLabel.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(16.scalable)
            $0.left.equalTo(locationLabel.snp.left)
            $0.right.equalTo(locationLabel.snp.right)
        }
        
        view.addSubview(commentLabel)
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(temperatureLabel.snp.bottom).offset(16.scalable)
            $0.left.equalTo(temperatureLabel.snp.left)
            $0.right.equalTo(temperatureLabel.snp.right)
        }
        
        view.addSubview(updateLabel)
        updateLabel.snp.makeConstraints {
            $0.top.equalTo(commentLabel.snp.bottom).offset(16.scalable)
            $0.left.equalTo(commentLabel.snp.left)
            $0.right.equalTo(commentLabel.snp.right)
        }
    }
    
    func setupBindings() {
        viewModel?.authorizationStatus.bind { [weak self] value in
            guard let value else {
                return
            }
            
            switch value {
            case    .restricted,
                    .denied:
                self?.showNoPermitionAlert()
            default:
                break
            }
        }
        
        viewModel?.commentText.bind { [weak self] value in
            guard let value else {
                return
            }
            
            self?.commentLabel.text = value
        }
        
        viewModel?.locationText.bind { [weak self] value in
            guard let value else {
                return
            }
            
            self?.locationLabel.text = value
        }
        
        viewModel?.temperature.bind { [weak self] value in
            guard let value else {
                return
            }
            
            self?.temperatureLabel.text = "\(value)°C"
        }
        
        viewModel?.lastUpdate.bind { [weak self] value in
            guard let value else {
                return
            }
            
            self?.updateLabel.text = "Последнее обновление: \(value)"
        }
    }
}

// MARK: - Helpers
private extension MainViewController {
    func showNoPermitionAlert() {
        showAlert(title: "Ошибка!",
                  message: "Работа приложения невозможна без информации о текущем местоположении. Дайте разрешение в настройках.",
                  firstActionTitle: "Настройки",
                  secondActionTitle: "Отмена",
                  firstCompletion: { [weak self] in
                    self?.showSettings()
                  },
                  secondCompletion: nil)
    }
    
    func showSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { _ in })
        }
    }
    
    @objc
    func refreshLocation() {
        viewModel?.refreshLocation()
    }
}
