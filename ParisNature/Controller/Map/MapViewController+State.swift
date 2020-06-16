//
//  MapViewController+State.swift
//  ParisNature
//
//  Created by co5ta on 20/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//
import UIKit

// MARK: - State
extension MapViewController {
    
    /// The available states of the view controller
    enum State {
        // List of states
        case neutral
        case loading
        case placesList
        case cluster(_ places: [Place])
        case placeDetail(_ place: Place?)
        case message(_ error: NetworkError)
    }
    
    /// Adjusts the views according to view controller state
    func adjustViews() {
        switch state {
        case .neutral:
            initDisplay()
        case .loading:
            displayLoading()
        case .placesList:
            displayPlacesList()
        case .cluster(let places):
            displayCluster(of: places)
        case .placeDetail(let place):
            displayDetail(of: place)
        case .message(let error):
            displayMessage(error)
        }
    }
    
    private func initDisplay() {
//        toggleViews(show: listVC.listView.errorView)
    }
    
    /// Displays loading
    private func displayLoading() {
        mapDelegate.isFollowing = false
        toggleViews(show: listVC.listView.loadingView)
        listPanel.move(to: .half, animated: true)
    }
    
    /// Displays the list of places
    private func displayPlacesList() {
        let position = panelDelegate.lastPanelPosition ?? .half
        toggleViews(show: listVC.listView.tableView)
        listPanel.move(to: position, animated: true)
        detailPanel.move(to: .hidden, animated: true)
    }
    
    /// DIsplays the places of a cluster
    private func displayCluster(of places: [Place]) {
        listVC.places = places
        toggleViews(show: listVC.listView.tableView)
        listPanel.move(to: .half, animated: true)
        detailPanel.move(to: .hidden, animated: true)
    }
    
    /// Displays the detail of a place
    private func displayDetail(of place: Place?) {
        detailVC.place = place
        panelDelegate.lastPanelPosition = listPanel.position
        listPanel.move(to: .hidden, animated: true)
        detailPanel.move(to: .half, animated: true)
    }
    
    private func displayMessage(_ error: NetworkError) {
        listVC.listView.errorView.error = error
        toggleViews(show: listVC.listView.errorView)
        listPanel.move(to: .full, animated: true)
        detailPanel.move(to: .hidden, animated: true)
    }
    
    /// Toggles the views of the list view controller
    private func toggleViews(show view: UIView) {
        [listVC.listView.loadingView, listVC.listView.tableView, listVC.listView.errorView].forEach {
            $0.isHidden = ($0 == view) ? false : true
        }
    }
}
