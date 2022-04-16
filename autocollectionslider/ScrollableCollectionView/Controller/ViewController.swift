//
//  ViewController.swift
//  ScrollableCollectionView
//
//  Created by Sabir Myrzaev on 17/4/22.
//

import UIKit

let tableCellIdentifier = "CustomTableViewCell"

class ViewController: UIViewController {

    var staticCollectionData = ["image_1","image_2","image_3","image_4","image_5"]
    
    private var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.register(UINib(nibName: tableCellIdentifier, bundle: nil), forCellReuseIdentifier: tableCellIdentifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true        
    }
}

// MARK: TableView Extensions
extension ViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as? CustomTableViewCell else {
            fatalError("Cell is not an instance of CustomTableViewCell")
        }
        
        cell.configureCell(arr: staticCollectionData)
        return cell
    }
}

