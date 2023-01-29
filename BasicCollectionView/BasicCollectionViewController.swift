//
//  BasicCollectionViewController.swift
//  BasicCollectionView
//
//  Created by Valiantsin Harshkou on 17.01.23.
//

import UIKit

private let reuseIdentifier = "Cell"

// Variable with the list of U.S. states
private let items = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]

class BasicCollectionViewController: UICollectionViewController, UISearchResultsUpdating {
    
    // Identify the sections in the "collectionView".
    enum Section: CaseIterable {
        case main
    }
    
    // Implicitly unwrapped variable for the data source that uses the "Section" type.
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!
    
    // Method that initializes the diffable data source.
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, item) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! BasicCollectionViewCell
            
            cell.label.text = item
            
            return cell
        })
        // Apply the snapshot to the data source.
        dataSource.apply(filteredItemsSnapshot)
    }
    
    // The property that represents an up-to-date snapshot of filtered data.
    var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<Section, String> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredItems)
        
        return snapshot
    }
    
    let searchController = UISearchController()
    
    // The property that will be used to store the filtered results
    var filteredItems: [String] = items
    
    func updateSearchResults(for searchController: UISearchController) {
        // Respond to the user's search implementing.
        if let searchString = searchController.searchBar.text,
           searchString.isEmpty == false {
            // If the text is present, the "filter" method is used to remove items that don't match the search string.
            filteredItems = items.filter { (item) -> Bool in item.localizedCaseInsensitiveContains(searchString)}
        } else {
            filteredItems = items
        }
        
        // Re-query the data source.
        dataSource.apply(filteredItemsSnapshot, animatingDifferences: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the search controller
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.hidesSearchBarWhenScrolling = false

        collectionView.setCollectionViewLayout(generateLayout(), animated: false)
        
        createDataSource()
    }
    
    // Composing the layout
    private func generateLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Adjust the item spacing
        let spacing: CGFloat = 10
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(70.0))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            repeatingSubitem: item,
            count: 1
        )
        
        // Set the space between the edge and the next object
        group.contentInsets = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: 0, trailing: spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }

}
