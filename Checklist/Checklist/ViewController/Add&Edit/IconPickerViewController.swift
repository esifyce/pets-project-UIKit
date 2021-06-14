//
//  IconPickerViewController.swift
//  Checklist
//
//  Created by Sabir Myrzaev on 14.06.2021.
//

import UIKit

protocol IconPickerViewControllerDelegate: AnyObject {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String)
}

class IconPickerViewController: UITableViewController {

    weak var delegate: IconPickerViewControllerDelegate?
    
    let icons = [
        "No Icon", "Appointments", "Birthdays", "Chores",
        "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return icons.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell", for: indexPath)

        let iconName = icons[indexPath.row]
        guard let label = cell.textLabel else { return cell }
        label.text = iconName
        guard let imageCell = cell.imageView else { return cell }
        imageCell.image = UIImage(named: iconName)
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
}

