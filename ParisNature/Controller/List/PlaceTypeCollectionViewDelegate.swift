//
//  PlaceTypeListDelegate.swift
//  ParisNature
//
//  Created by co5ta on 10/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// Delegate of the collection view  containing the list of place types
class CollectionViewDelegate: NSObject {

    /// View controller of the places list
    weak var listVC: ListViewController?
    /// List of all place type buttons
    var placeTypeButtons = [UIButton]()
}

// MARK: - UICollectionViewDelegate
extension CollectionViewDelegate: UICollectionViewDelegateFlowLayout {

    /// Asks the delegate for the size of the specified item’s cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let listVC = listVC else { return CGSize(width: 0, height: 0) }
        let divisor = CGFloat(integerLiteral: PlaceType.parents.count)
        return CGSize(width: listVC.view.frame.width / divisor, height: collectionView.frame.height)
    }

    /// Asks the delegate for the spacing between successive rows or columns of a section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

// MARK: - UICollectionViewDataSource
extension CollectionViewDelegate: UICollectionViewDataSource {

    /// Asks your data source object for the number of items in the specified section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlaceType.parents.count
    }

    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceTypeCell.identifier,
                                                            for: indexPath) as? PlaceTypeCell
        else { return UICollectionViewCell() }
        cell.placeType = PlaceType.parents[indexPath.row]
        cell.imageButton.addTarget(self, action: #selector(imageButtonTapped(button:)), for: .touchUpInside)
        placeTypeButtons.append(cell.imageButton)
        return cell
    }
}

// MARK: - Actions
extension CollectionViewDelegate {

    /// Launchs the search to get the places asken by the user
    @objc
    func imageButtonTapped(button: UIButton) {
        guard button.isSelected == false, let listVC = listVC else { return }
        placeTypeButtons.forEach { $0.isSelected = ($0 != button) ? false : true }
        listVC.subTypeCollectionViewDelegate.titleButtons.forEach {
            listVC.subTypeCollectionViewDelegate.setState(selected: false, on: $0)
        }
        
        guard let cell = button.superview?.superview as? PlaceTypeCell,
            let placeType = cell.placeType
            else { return }
        listVC.removePlaces()
        listVC.placeType = placeType
        listVC.mapVC?.panelDelegate.lastPanelPosition = nil
        listVC.getPlaces(placeType: placeType)
    }
}
