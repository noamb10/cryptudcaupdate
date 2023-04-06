import UIKit

class SettingsViewController: UITableViewController {
    
    let userManager = UserManager.shared
    let networkManager = NetworkManager.shared
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func logout() {
        userManager.logout()
        networkManager.cancelAllRequests()
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 2
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.section == 0 {
            cell.textLabel?.text = "Account"
            cell.accessoryType = .disclosureIndicator
        } else {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Logout"
                cell.textLabel?.textColor = .red
            } else {
                cell.textLabel?.text = "About"
                cell.accessoryType = .disclosureIndicator
            }
        }
        return cell
    }
    
    // MARK: - Table View Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let accountVC = AccountViewController()
            navigationController?.pushViewController(accountVC, animated: true)
        } else {
            if indexPath.row == 0 {
                let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
                    self.logout()
                }))
                present(alert, animated: true, completion: nil)
            } else {
                let aboutVC = AboutViewController()
                navigationController?.pushViewController(aboutVC, animated: true)
            }
        }
    }
}
