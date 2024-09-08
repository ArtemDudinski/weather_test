import UIKit

class ForecastViewController: BaseViewController {
    
    private lazy var locationLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.scalable, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = 44
        tableView.register(ForecastCell.self, forCellReuseIdentifier: ForecastCell.identifier)
        return tableView
    }()
    
    private var dataSource: [ForecastTableViewDataSource] = []
    
    var viewModel: ForecastViewModel? {
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
private extension ForecastViewController {
    func setup() {
        navigationItem.title = "Forecast"
        view.backgroundColor = .white
        
        viewModel?.requestForecast()
        
        view.addSubview(locationLabel)
        locationLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16.scalable)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(locationLabel.snp.bottom).offset(16.scalable)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupBindings() {
        viewModel?.location.bind { [weak self] value in
            guard let value else {
                return
            }
            
            self?.locationLabel.text = "Прогноз погоды на 7 дней в\n\(value)"
        }
        
        viewModel?.dataSource.bind { [weak self] value in
            guard let value else {
                return
            }
            
            self?.dataSource = value
            self?.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ForecastCell.identifier, for: indexPath) as? ForecastCell else {
            return UITableViewCell()
        }
        
        if let item = dataSource[safe: indexPath.row] {
            cell.configure(item: item)
        }
        
        return cell
    }
}
