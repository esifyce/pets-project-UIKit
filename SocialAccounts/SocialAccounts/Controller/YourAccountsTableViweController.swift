//
//  YourAccountsTableViweController.swift
//  SocialAccounts
//
//  Created by Sabir Myrzaev on 13.02.2022.
//

import UIKit

extension YourAccountsTableViweController: NewSocialAccountDelegate {
    func newSocialAccount(title: String, url: String) {
        let newAccount = SocialAccount(title: title, url: url, imageURL: "medium")
        let section = 1
        let row = self.socialAccounts[section].count
        let insertionIndexPath = IndexPath(row: row, section: section)
        self.socialAccounts[section].append(newAccount)
        tableView.insertRows(at: [insertionIndexPath], with: .automatic)
    }
}

class YourAccountsTableViweController: UITableViewController {
    
    fileprivate var socialAccounts: [[SocialAccount]] = [
        [
            SocialAccount(title: "Instagram", url: "https://www.instagram.com/markshatoff", imageURL: "instagram"),
            SocialAccount(title: "Twitter", url: "https://www.twitter.com/maxcodes1", imageURL: "twitter"),
            SocialAccount(title: "Medium", url: "https://www.medium.com/@max.codes", imageURL: "medium")
        ],
        [
            SocialAccount(title: "Instagram", url: "https://www.instagram.com/praline.kg", imageURL: "instagram"),
            SocialAccount(title: "Twitter", url: "https://www.twitter.com/maxcodes1", imageURL: "twitter"),
            SocialAccount(title: "Pinterest", url: "https://www.pinterest.com/pinterest", imageURL: "pinterest")
        ],
        [
            SocialAccount(title: "Facebook", url: "https://www.facebook.com/", imageURL: "facebook")
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBarButtonItems()
    }
    
    fileprivate func setupBarButtonItems() {
        let AddSocial: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addNewSocialAccount))
        
        navigationItem.rightBarButtonItem = AddSocial
    }
    
    @objc fileprivate func addNewSocialAccount() {
        let newSocialAccountVC = NewSocialAccountViewController()
        newSocialAccountVC.delegate = self
        let newSocialAccountNavigationController = UINavigationController(rootViewController: newSocialAccountVC)
        present(newSocialAccountNavigationController, animated: true, completion: nil)
    }
    
    fileprivate func setupTableView() {
        tableView.register(SocialAccountCell.self, forCellReuseIdentifier: SocialAccountCell.identifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return socialAccounts[section].count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SocialAccountCell.identifier, for: indexPath) as? SocialAccountCell else { return UITableViewCell() }
        let socialAccount = socialAccounts[indexPath.section][indexPath.row]
        
        cell.socialCell = socialAccount
        
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return socialAccounts.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let socialAccount = socialAccounts[indexPath.section][indexPath.row]
        guard let appURL = URL(string: socialAccount.url) else { return }
        UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
    }
    
    // MARK: - HEADER
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        
        if section == 0 {
            label.text = "My Accounts"
        } else if section == 1 {
            label.text = "Favorite Accounts"
        } else {
            label.text = "Default Section #\(section)"
        }
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(label)
        
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        label.heightAnchor.constraint(equalToConstant: 30).isActive = true
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    // MARK: - ROW ACTIONS
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // Delete action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            
            self.socialAccounts[indexPath.section].remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        // Share action
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (action, sourceView, completionHandler) in
            
        }
        
        // Change the button's color
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")

        editAction.backgroundColor = UIColor.systemOrange
        
        // Configure both actions as swipe action
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            
        return swipeConfiguration
    }
}
