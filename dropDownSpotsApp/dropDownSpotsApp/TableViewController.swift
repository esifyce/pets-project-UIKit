//
//  TableViewController.swift
//  dropDownSpotsApp
//
//  Created by Sabir Myrzaev on 12.02.2022.
//

import UIKit

extension TableViewController: UIViewControllerPreviewingDelegate {
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        let vc = ImageController()
        if let indexPath = tableView.indexPathForRow(at: location) {
            let section = sections[indexPath.section]
            let cellData = section.data[indexPath.row]
            vc.cellData = cellData
        }
        return vc
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
    
}

class TableViewController: UITableViewController {
    
    fileprivate let CELL_ID = "cell"
    
    fileprivate var sections: [SectionData] = [
        SectionData(
            open: true,
            data: [
                CellData(title: "Section", featureImage: UIImage(named: "zero")!)
                ]
        ),
        SectionData(
            open: true,
            data: [
                CellData(title: "Section", featureImage: UIImage(named: "one")!)
            ]
        ),
        SectionData(
            open: true,
            data: [
                CellData(title: "Section", featureImage: UIImage(named: "zero")!),
                CellData(title: "Section", featureImage: UIImage(named: "two")!)
            ]
        )
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.init(red: 228/255, green: 230/255, blue: 234/255, alpha: 1)
        navigationItem.title = "spots"
        setUpTableView()
        
        // check device for FourceTouch capability
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    fileprivate func setUpTableView() {
        tableView.register(CardCell.self, forCellReuseIdentifier: CELL_ID)
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
    }
    
    // MARK: - CELL DATA
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as? CardCell else { return UITableViewCell() }
        
        let section = sections[indexPath.section]
        let cellData = section.data[indexPath.row]
        
        cell.cellData = cellData
        cell.animate()
    
        return cell
    }
    
    // MARK: - Section & Rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !sections[section].open {
            return 0
        }
        return sections[section].data.count
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    // MARK: - HEADER SECTION
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        button.tag = section
        button.setTitle("close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(self.openSection), for: .touchUpInside)
        return button
    }
    
    @objc fileprivate func openSection(button: UIButton) {
        let section = button.tag
        
        var indexPaths = [IndexPath]()
        for row in sections[section].data.indices {
            let indexPathToDelete = IndexPath(row: row, section: section)
            indexPaths.append(indexPathToDelete)
        }
        
        // Is this section open or closed
        // flipping true or false
        let isOpen = sections[section].open
        sections[section].open = !isOpen
        button.setTitle(isOpen ? "open" : "close", for: .normal)
        
        if isOpen {
            tableView.deleteRows(at: indexPaths, with: .fade)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
        }
    }
}

