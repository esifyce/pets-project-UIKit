//
//  DiscoverTableViewController.swift
//  FoodPin
//
//  Created by Sabir Myrzaev on 3/4/22.
//

import UIKit
import CloudKit

class DiscoverTableViewController: UITableViewController {
    
    var restaurants: [CKRecord] = []
    var spinner = UIActivityIndicatorView()
    
    lazy var dataSource = configureDataSource()
    
    private var imageCache = NSCache<CKRecord.ID, NSURL>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        spinner.style = .medium
        spinner.hidesWhenStopped = true
        view.addSubview(spinner)
        
        // Pull to Refresh COntrol
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = .white
        refreshControl?.tintColor = .gray
        refreshControl?.addTarget(self, action: #selector(fetchRecordsFromCloud), for: .valueChanged)
        
        // Define layout constrants for the spinner
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([spinner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150.0),
                                     spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor)])
        // Activate the spinner
        spinner.startAnimating()
        
        tableView.cellLayoutMarginsFollowReadableWidth = true
        navigationController?.navigationBar.prefersLargeTitles = true
        // Customize the navigation bar appearance
        if let appearance = navigationController?.navigationBar.standardAppearance {
            appearance.configureWithTransparentBackground()
            if let customFont = UIFont(name: "Nunito-Bold", size: 45.0) {
                appearance.titleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!]
                appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "NavigationBarTitle")!, .font: customFont]
            }
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        // Fetch record from iCloud
        Task.init(priority: .high) {
            do {
                try await fetchRecordsFromCloud()
            } catch {
                print(error)
            }
        }
        // Set the data source of the table view for Diffable Data Source
        tableView.dataSource = dataSource
    }
    
    @objc func fetchRecordsFromCloud() {
        
        if let refreshControl = self.refreshControl {
            if refreshControl.isRefreshing {
                refreshControl.endRefreshing()
            }
        }
        // Fetch data using Convenience API
        let cloudContainer = CKContainer.default()
        let publicDatabase = cloudContainer.publicCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "Restaurant", predicate: predicate)
        // Create the query operation with the query
        let queryOperation = CKQueryOperation(query: query)
        queryOperation.desiredKeys = ["name"]
        queryOperation.queuePriority = .veryHigh
        queryOperation.resultsLimit = 50
        queryOperation.recordMatchedBlock = { (recordID, result) -> Void in
            do {
                if let _ = self.restaurants.first(where: { $0.recordID == recordID }) {
                    return
                }
                self.restaurants.append(try result.get())
            } catch {
                print(error)
            }
        }
        queryOperation.queryCompletionBlock = { [unowned self] (cursor, error) -> Void in
            if let error = error {
                print("Failed to get data from iCloud - \(error.localizedDescription)")
                return
            }
            print("Successfully retrieve the data from iCloud")
            self.updateSnapshot()
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
            }
        }
        // Execute the query
        publicDatabase.add(queryOperation)
    }
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, CKRecord> {
        let cellIdentifier = "discovercell"
        let dataSource = UITableViewDiffableDataSource<Section, CKRecord>(tableView: tableView) { (tableView, indexPath, restaurant) -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
            cell.textLabel?.text = restaurant.object(forKey: "name") as? String
            cell.imageView?.image = UIImage(systemName: "photo")
            cell.imageView?.tintColor = .black
            
            // check if the image is stored im cache
            if let imageFileURL = self.imageCache.object(forKey: restaurant.recordID) {
                // Fetch image from cache
                print("Get image from cache")
                if let imageData = try? Data.init(contentsOf: imageFileURL as URL) {
                    cell.imageView?.image = UIImage(data: imageData)
                }
            } else {
                let publicDatabase = CKContainer.default().publicCloudDatabase
                let fetchRecordsImageOperation = CKFetchRecordsOperation(recordIDs: [restaurant.recordID])
                fetchRecordsImageOperation.desiredKeys = ["image"]
                fetchRecordsImageOperation.queuePriority = .veryHigh
                
                fetchRecordsImageOperation.perRecordResultBlock = { (recordID, result) in
                    do {
                        let restaurantRecord = try result.get()
                        if let image = restaurant.object(forKey: "image"), let imageAsset = image as? CKAsset {
                            
                            if let imageData = try? Data.init(contentsOf: imageAsset.fileURL!) {
                                DispatchQueue.main.async {
                                    cell.imageView?.image = UIImage(data: imageData)
                                    cell.setNeedsLayout()
                                }
                                self.imageCache.setObject(imageAsset.fileURL! as NSURL, forKey: restaurant.recordID)
                            }
                        }
                    } catch {
                        print("DEBUG: Failed to get image: \(error.localizedDescription)")
                    }
                }
                publicDatabase.add(fetchRecordsImageOperation)
            }
            return cell
        }
        return dataSource
    }
    
    func updateSnapshot(animatingChange: Bool = false) {
        // Create a snapshot and populate the data
        var snapshot = NSDiffableDataSourceSnapshot<Section, CKRecord>()
        snapshot.appendSections([.all])
        snapshot.appendItems(restaurants, toSection: .all)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
