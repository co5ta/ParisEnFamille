//
//  PlaceTypeListDelegate.swift
//  ParisNature
//
//  Created by co5ta on 10/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// Delegate of the collection view  containing the list of place types
class PlaceTypeListDelegate: NSObject {

    /// View controller of the list of places
    weak var listVC: ListViewController?
}

// MARK: - UICollectionViewDataSource
extension PlaceTypeListDelegate: UICollectionViewDataSource {
    
    /// Asks your data source object for the number of items in the specified section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlaceType.allCases.count
    }
    
    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlaceTypeCell.identifier,
            for: indexPath) as? PlaceTypeCell,
            let listVC = listVC
            else { return UICollectionViewCell() }
        
        cell.placeType = PlaceType.allCases[indexPath.row]
        cell.imageButton.addTarget(listVC, action: #selector(listVC.imageButtonTapped(sender:)), for: .touchUpInside)
        listVC.imagesButton.append(cell.imageButton)
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PlaceTypeListDelegate: UICollectionViewDelegateFlowLayout {
    
    /// Asks the delegate for the size of the specified item’s cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let listVC = listVC else { return CGSize(width: 0, height: 0) }
        let divisor = CGFloat(integerLiteral: PlaceType.allCases.count)
        return CGSize(width: listVC.view.frame.width / divisor, height: collectionView.frame.height)
    }

    /// Asks the delegate for the spacing between successive rows or columns of a section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
