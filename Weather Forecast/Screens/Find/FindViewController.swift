import UIKit

class FindViewController: BaseViewController {
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17.scalable, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Введите название города в котором хотите посмотреть погоду"
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.showsCancelButton = true
        searchBar.tintColor = .black
        searchBar.delegate = self
        return searchBar
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        return tableView
    }()
    
    private var dataSource: [ForecastTableViewDataSource] = []
    
    var viewModel: FindViewModel? {
        didSet {
            baseViewModel = viewModel
            setupBindings()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        viewModel?.checkConnection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
}

// MARK: - Setup
private extension FindViewController {
    func setup() {
        navigationItem.title = "Find"
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16.scalable)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
        }
        
        view.addSubview(searchBar)
        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.scalable)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(16.scalable)
            $0.left.equalToSuperview()
            $0.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func setupBindings() {
        viewModel?.placemarks.bind { [weak self] value in
            guard value != nil else {
                return
            }
            
            self?.tableView.reloadData()
        }
        
        viewModel?.connection.bind { [weak self] value in
            guard let value = value else {
                return
            }
            
            if value == false {
                self?.showNoConnectionAlert()
            }
        }
    }
}

// MARK: - Helpers
private extension FindViewController {
    func showNoConnectionAlert() {
        showAlert(title: "Ошибка!",
                  message: "Нельзя воспользоватся данной функцией. Проверьте соединение с интернетом!",
                  firstActionTitle: "OK",
                  firstCompletion: { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        })
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FindViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.placemarksCount ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel else {
            return UITableViewCell()
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: UITableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = viewModel.getPlacemarkTitle(from: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel?.selectPlacemark(from: indexPath.row)
        navigationController?.dismiss(animated: true)
    }
}

// MARK: - UISearchBarDelegate
extension FindViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.findPlacemarks(for: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        view.endEditing(true)
        navigationController?.dismiss(animated: true)
    }
}
