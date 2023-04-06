import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    private let networkManager = NetworkManager()
    private let authenticationManager = AuthenticationManager.shared
    
    private var portfolio: Portfolio?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "CustomCell")
        authenticationManager.handleRedirectURL()
        updateUI()
    }
    
    // MARK: - IBActions
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        authenticationManager.authenticate { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.updateUI()
                case .failure(let error):
                    self.showAlert(withTitle: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func signOutButtonTapped(_ sender: UIButton) {
        authenticationManager.signOut()
        updateUI()
    }
    
    // MARK: - Private Methods
    
    private func updateUI() {
        if authenticationManager.isAuthenticated {
            signInButton.isHidden = true
            signOutButton.isHidden = false
            getPortfolio()
        } else {
            signInButton.isHidden = false
            signOutButton.isHidden = true
            portfolio = nil
            tableView.reloadData()
        }
    }
    
    private func getPortfolio() {
        networkManager.getPortfolio { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let portfolio):
                    self.portfolio = portfolio
                    self.tableView.reloadData()
                case .failure(let error):
                    self.showAlert(withTitle: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func showAlert(withTitle title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return portfolio?.transactions.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomTableViewCell
        guard let transaction = portfolio?.transactions[indexPath.row] else {
            return cell
        }
        cell.configure(with: transaction)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let transaction = portfolio?.transactions[indexPath.row] else {
            return
        }
        // Perform some action with selected transaction
    }
}
