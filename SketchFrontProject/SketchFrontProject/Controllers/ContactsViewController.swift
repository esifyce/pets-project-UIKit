//
//  ContactsViewController.swift
//  SketchFrontProject
//
//  Created by Sabir Myrzaev on 07.06.2021.
//

import UIKit

class ContactsViewController: UIViewController {

    let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addBarButtonItemTapped))
    let groupsBarButtonItem = UIBarButtonItem(title: "Groups", style: .plain, target: self, action: #selector(groupsBarButtonItemTapped))
    
    var dataSource: UICollectionViewDiffableDataSource<ContactsModel.UserCollection, ContactsModel.User>! = nil
    var currentSnapshot: NSDiffableDataSourceSnapshot<ContactsModel.UserCollection, ContactsModel.User>! = nil
    var collectionView: UICollectionView!
    
    let contactsModel = ContactsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        
        
        setupNavigationBar()
        setupCollectionView()
        createDataSource()
        reloadData()
    }

    private func setupNavigationBar() {
        let searchController = UISearchController()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
            // будет срабатывать когда будем вводить каждый символ в search bar
        searchController.searchBar.delegate = self
        
        navigationItem.leftBarButtonItem = groupsBarButtonItem
        navigationItem.rightBarButtonItem = addBarButtonItem
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Contacts"
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout())
        
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeader.reuseId)
        // зарегестрировать новый тип ячеек
        collectionView.register(ProfileCell.self, forCellWithReuseIdentifier: ProfileCell.reuseId)
        collectionView.register(FavouriteCell.self, forCellWithReuseIdentifier: FavouriteCell.reuseId)
        collectionView.register(ContactCell.self, forCellWithReuseIdentifier: ContactCell.reuseId)
        
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnviroment) -> NSCollectionLayoutSection? in
            
            let type = self.currentSnapshot.sectionIdentifiers[sectionIndex].type
            
            switch type {
            case .profile:
                return self.createProfile()
            case .fovourites:
                return self.createFavourites()
            case .contacts:
                return self.createContacts()
            }
        }
        // между секциями установили 16 поинтов
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 16
        layout.configuration = config
        return layout
    }
    
    private func createProfile() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(58))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        // задает отступы различных границ
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        return section
    }
    
    private func createFavourites() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(110), heightDimension: .absolute(120))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 16, bottom: 0, trailing: 16)
        
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    private func createContacts() -> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(55))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 1
        section.contentInsets = NSDirectionalEdgeInsets.init(top: 16, leading: 16, bottom: 0, trailing: 16)
        
        let selectionHeaderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(25))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: selectionHeaderSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    // MARK: ReloadData
    private func reloadData() {
        currentSnapshot = NSDiffableDataSourceSnapshot<ContactsModel.UserCollection, ContactsModel.User>()
        
        contactsModel.collections.forEach { (collection) in
            currentSnapshot.appendSections([collection])
            currentSnapshot.appendItems(collection.users)
        }
        // зафиксируем все изменения в dataSource
        dataSource.apply(currentSnapshot, animatingDifferences: true)
    }
    
// MARK: DataSource
    func createDataSource() {
        // ячейка для юзера
        dataSource = UICollectionViewDiffableDataSource<ContactsModel.UserCollection, ContactsModel.User>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, user) -> UICollectionViewCell? in
            
            var user = user
            
            let type = self.currentSnapshot.sectionIdentifiers[indexPath.section].type
            let users = self.currentSnapshot.sectionIdentifiers[indexPath.section].users
            
            if type == .contacts {
                if users.count > 1, users.first == user {
                    user.direction = .top
                } else if users.count == 1 {
                    user.direction = .all
                } else if users.last == user {
                    user.direction = .bottom
                } else {
                    user.direction = .nope
                }
            }
            // для какой секции мой тип ячеек у меня будет
            switch type {
            case .profile: return self.configure(collectionView: collectionView, cellType: ProfileCell.self, with: user, for: indexPath)
            case .fovourites: return self.configure(collectionView: collectionView, cellType: FavouriteCell.self, with: user, for: indexPath)
            case .contacts: return self.configure(collectionView: collectionView, cellType: ContactCell.self, with: user, for: indexPath)
            }
        })
        // зарегестрировали новй header и добавили в datasource
        dataSource.supplementaryViewProvider = { [weak self] (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self = self, let snapshot = self.currentSnapshot else { return nil }
            
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseId, for: indexPath) as? SectionHeader {
                let collection = snapshot.sectionIdentifiers[indexPath.section]
                sectionHeader.titleLable.text = collection.header
                return sectionHeader
            } else {
                fatalError("Cannot create new supplementary")
            }
            
        }
    }
}


// MARK: Actions
extension ContactsViewController {
    
    @objc func addBarButtonItemTapped() {
        print(#function)
    }
    
    @objc func groupsBarButtonItemTapped() {
        print(#function)
    }
}

// MARK: UISearchBarDelegate
extension ContactsViewController: UISearchBarDelegate {
    // при печати выводит текст в консоль
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}

