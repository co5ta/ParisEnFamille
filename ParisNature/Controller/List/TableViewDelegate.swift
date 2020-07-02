//
//  TableViewDelegate.swift
//  ParisNature
//
//  Created by co5ta on 10/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// Delegate of the table view which containing the list of places
class TableViewDelegate: NSObject {
    
    /// View controller of the places list
    weak var listVC: ListViewController?
}

// MARK: - UITableViewDataSource
extension TableViewDelegate: UITableViewDataSource {
    
    /// Tells the data source to return the number of rows in a given section of a table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listVC?.places.count ?? 0
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.identifier,
                                                      for: indexPath) as? PlaceCell
            else { return UITableViewCell() }
        
        let place = listVC?.places[indexPath.row]
        cell.place = place
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TableViewDelegate: UITableViewDelegate {
    
    /// Tells the delegate that the specified row is now selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PlaceCell,
            let mapVC = listVC?.mapVC
            else { return }
        
        if mapVC.state == .placesList {
            mapVC.panelDelegate.lastPanelPosition = mapVC.listPanel.position
        }
        mapVC.mapViewDelegate.selectAnnotation(of: cell.place)
    }
}
