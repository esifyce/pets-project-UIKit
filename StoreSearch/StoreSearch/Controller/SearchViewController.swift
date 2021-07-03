//
//  SearchViewController.swift
//  StoreSearch
//
//  Created by Sabir Myrzaev on 24.06.2021.
//

import UIKit

class SearchViewController: UIViewController {
    
    weak var splitViewDetail: DetailViewController?
    var landscapeVC: LandscapeViewController?
    private let search = Search()

    
    // MARK: - Outlets
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    struct TableView {
        struct CellIdentifiers {
            static let searchResultCell = "SearchResultCell"
            static let nothingFoundCell = "NothingFoundCell"
            static let loadingCell = "LoadingCell"
        }
    }
    
    // MARK: - VC life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.contentInset = UIEdgeInsets(top: 94, left: 0, bottom: 0, right: 0)
        
        var cellNib = UINib(nibName: TableView.CellIdentifiers.searchResultCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.searchResultCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.nothingFoundCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.nothingFoundCell)
        cellNib = UINib(nibName: TableView.CellIdentifiers.loadingCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: TableView.CellIdentifiers.loadingCell)
        
        searchBar.becomeFirstResponder()
        
        title = NSLocalizedString("Search", comment: "split view primary button")
        
        if UIDevice.current.userInterfaceIdiom != .pad {
            searchBar.becomeFirstResponder()
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        switch newCollection.verticalSizeClass {
        case .compact:
            if newCollection.horizontalSizeClass == .compact {
            showLandscape(with: coordinator)
            }
        case .regular, .unspecified:
            hideLandscape(with: coordinator)
        @unknown default:
            break
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if UIDevice.current.userInterfaceIdiom == .phone {
            navigationController?.navigationBar.isHidden = true
        }
    }
    // MARK: - Actions
    
    @IBAction func segmentedChanged(_ sender: UISegmentedControl) {
        performSearch()
    }
    
    // MARK: - Helper methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if case .results(let list) = search.state {
            let detailVC = segue.destination as! DetailViewController
            let indexPath = sender as! IndexPath
            let searchResult = list[indexPath.row]
            detailVC.searchResult = searchResult
                detailVC.isPopUp = true
            }
        }
    }
    
    func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "No access to Itunes." + "Repeate please.", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        
        guard landscapeVC == nil else { return }
        
        landscapeVC = storyboard!.instantiateViewController(withIdentifier: "LandscapeViewController") as? LandscapeViewController
        if let controller = landscapeVC {
            controller.search = search
            controller.view.frame = view.bounds
            controller.view.alpha = 0
            view.addSubview(controller.view)
            addChild(controller)
            coordinator.animate { _ in
                controller.view.alpha = 1
                self.searchBar.resignFirstResponder()
            } completion: { _ in
                controller.didMove(toParent: self)
            }
            if self.presentedViewController != nil {
                self.dismiss(animated: true, completion: nil)
            }

        }
    }

    private func hidePrimaryPane() {
        UIView.animate(withDuration: 0.25) {
            self.splitViewController!.preferredDisplayMode = .secondaryOnly
        } completion: { _ in
            self.splitViewController!.preferredDisplayMode = .automatic
        }

    }
    
    func hideLandscape(with coordinator: UIViewControllerTransitionCoordinator) {
        if let controller = landscapeVC {
            controller.willMove(toParent: nil)
            coordinator.animate { _ in
                controller.view.alpha = 0
            } completion: { _ in
                controller.view.removeFromSuperview()
                controller.removeFromParent()
                self.landscapeVC = nil
            }
        }
        guard self.presentedViewController != nil else { return }
        self.dismiss(animated: true, completion: nil)
    }
}
// MARK: - SearchBar delegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        performSearch()
    }
    
    func performSearch() {
        if let category = Search.Category(rawValue: segmentedControl.selectedSegmentIndex) {
        search.performSearch(for: searchBar.text!, category: category) { success in
            if !success {
                self.showNetworkError()
            }
            self.tableView.reloadData()
            self.landscapeVC?.searchResultsReceived()
        }
        tableView.reloadData()
        searchBar.resignFirstResponder()
    }
        
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
        }
    }
}

// MARK: - TableView delegate and datasource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch search.state {
        case .notSearchedYet: return 0
        case .loading: return 1
        case .noResults: return 1
        case .results(let list): return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch search.state {
        case .notSearchedYet:
            fatalError("No access")
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.loadingCell, for: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        case .noResults:
            return tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.nothingFoundCell, for: indexPath)
        case .results(let list):
            let cell = tableView.dequeueReusableCell(withIdentifier: TableView.CellIdentifiers.searchResultCell, for: indexPath) as! SearchResultCell
            
            let searchResult = list[indexPath.row]
            cell.configure(for: searchResult)
            return cell
    }
}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        if view.window?.rootViewController?.traitCollection.horizontalSizeClass == .compact {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ShowDetail", sender: indexPath)
        } else {
            if case .results(let list) = search.state {
                splitViewDetail?.searchResult = list[indexPath.row]
            }
        }
        
        if splitViewController!.displayMode != .oneBesideSecondary {
            hidePrimaryPane()
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        switch search.state {
        case .notSearchedYet, .loading, .noResults:
            return nil
        case .results:
            return indexPath
        }
    }
}
