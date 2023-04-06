import UIKit

class PortfolioViewController: UIViewController {
    
    // MARK: - Properties
    
    private let tableView = UITableView()
    private let refreshControl = UIRefreshControl()
    private var portfolio: Portfolio?
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Portfolio"
        view.backgroundColor = .systemBackground
        
        setupTableView()
        setupRefreshControl()
        
        refresh()
    }
    
    // MARK: - Private Methods
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PortfolioTableViewCell.self, forCellReuseIdentifier: PortfolioTableViewCell.reuseIdentifier)
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupRefreshControl() {
        tableView.addSubview(refreshControl)
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        if AuthenticationManager.shared.isAuthenticated {
            fetchPortfolio()
        } else {
            refreshControl.endRefreshing()
            presentAuthenticationViewController()
        }
    }
    
    private func fetchPortfolio() {
        NetworkManager.shared.getPortfolio { [weak self] result in
            switch result {
            case .success(let portfolio):
                self?.portfolio = portfolio
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.refreshControl.endRefreshing()
                }
            case .failure(let error):
                print("Error fetching portfolio: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.refreshControl.endRefreshing()
                }
            }
        }
    }
    
    private func presentAuthenticationViewController() {
        let authenticationViewController = AuthenticationViewController()
        authenticationViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: authenticationViewController)
        present(navigationController, animated: true, completion: nil)
    }

}

// MARK: - UITableView Delegate & DataSource

extension PortfolioViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return portfolio?.assets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PortfolioTableViewCell.reuseIdentifier, for: indexPath) as? PortfolioTableViewCell else {
            return UITableViewCell()
        }
        
        if let asset = portfolio?.assets[indexPath.row] {
            cell.configure(with: asset)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

// MARK: - AuthenticationViewController Delegate

extension PortfolioViewController: AuthenticationViewControllerDelegate {
    
    func authenticationViewControllerDidAuthenticate() {
        dismiss(animated: true) {
            self.fetchPortfolio()
        }
    }
    
}
