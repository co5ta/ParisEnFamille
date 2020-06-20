//
//  SubtypeCollectionViewDelegate.swift
//  ParisNature
//
//  Created by co5ta on 18/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// Delegate of the collection view  containing the list of place subtypes
class SubTypeCollectionViewDelegate: NSObject {
    
    /// View controller of the places list
    weak var listVC: ListViewController?
    /// Subtypes place of the selected place type
    var subTypes: [String]?
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SubTypeCollectionViewDelegate: UICollectionViewDelegateFlowLayout {
    
    /// Asks the delegate for the size of the specified item’s cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: Config.screenSize.width / 3.5, height: collectionView.frame.height)
    }
    
    /// Asks the delegate for the spacing between successive rows or columns of a section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

// MARK: - UICollectionViewDataSource
extension SubTypeCollectionViewDelegate: UICollectionViewDataSource {
    
    /// Asks your data source object for the number of items in the specified section
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subTypes?.count ?? 0
    }
    
    /// Asks your data source object for the cell that corresponds to the specified item in the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubTypeCell.identifier,
                                                            for: indexPath) as? SubTypeCell
            else { return UICollectionViewCell() }
        cell.subType = subTypes?[indexPath.row]
        return cell
    }
    
    /// Reloads Data
    func update() {
        guard let placeType = listVC?.placeType else { return }
        subTypes = PlaceType.children[placeType]
        listVC?.listView.subTypeCollectionView.reloadData()
    }
}
