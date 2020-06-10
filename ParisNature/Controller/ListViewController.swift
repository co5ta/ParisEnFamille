//
//  PlacesViewController.swift
//  ParisNature
//
//  Created by co5ta on 16/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// Manages the display of list of places
class ListViewController: UIViewController {
    
    weak var mapVC: MapViewController?
    var visualEffectView: UIVisualEffectView!
    var collectionView: UICollectionView!
    var imagesButton = [UIButton]()
    let tableView = UITableView()
    var places = [Place]() { didSet {updateTableView(oldValue)} }
    var loadingView = UIActivityIndicatorView()
    var errorView = ErrorView()
}

// MARK: - Lifecycle
extension ListViewController {
    
    /// Called after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        configure()
    }
}

// MARK: - Setup
extension ListViewController {
    
    /// Configures the view controller
    private func configure() {
        view.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    /// Sets up the views
    private func setUpViews() {
        setUpVisualEffectView()
        setUpCollectionView()
        setUpTableView()
        setUpLoadingView()
        setUpErrorView()
        constrainViews()
    }
    
    /// Sets up the background view
    private func setUpVisualEffectView() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.backgroundColor = .white
        visualEffectView.alpha = 0.8
        view.addSubview(visualEffectView)
    }
    
    /// Sets up the collection view
    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(PlaceTypeCell.self, forCellWithReuseIdentifier: PlaceTypeCell.identifier)
        view.addSubview(collectionView)
    }
    
    /// Sets up the table view
    private func setUpTableView() {
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.identifier)
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
    }
    
    /// Sets up the loading view
    private func setUpLoadingView() {
        loadingView.startAnimating()
        loadingView.style = .gray
        loadingView.isHidden = true
        view.addSubview(loadingView)
    }
    
    /// Sets up error view
    private func setUpErrorView() {
        errorView.isHidden = true
        view.addSubview(errorView)
    }
}

// MARK: - Constraints
extension ListViewController {
    
    /// Constrains  views
    private func constrainViews() {
        constrainVisualEffectView()
        constrainCollectionView()
        constrainTableView()
        constrainLoadingView()
        constrainErrorView()
    }
    
    /// Constrains background view
    private func constrainVisualEffectView() {
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Constrains collection view
    private func constrainCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.width / 4)
        ])
    }
    
    /// Constrains table view
    private func constrainTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    /// Constrains loading view
    private func constrainLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.topAnchor.constraint(equalToSystemSpacingBelow: collectionView.bottomAnchor, multiplier: 5)
        ])
    }
    
    private func constrainErrorView() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension ListViewController: UICollectionViewDataSource {
    
    /// Asks your data source object for the number of items in the specified section.
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlaceType.allCases.count
    }
    
    /// Asks your data source object for the cell that corresponds to the specified item in the collection view.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: PlaceTypeCell.identifier,
            for: indexPath) as? PlaceTypeCell
            else { return UICollectionViewCell() }
        
        cell.placeType = PlaceType.allCases[indexPath.row]
        cell.imageButton.addTarget(self, action: #selector(imageButtonTapped(sender:)), for: .touchUpInside)
        imagesButton.append(cell.imageButton)
        return cell
    }
    
    /// Action after a button has been tapped
    @objc
    private func imageButtonTapped(sender: UIButton) {
        guard sender.isSelected == false else { return }
        imagesButton.forEach { $0.isSelected = ($0 != sender) ? false : true }
        guard let cell = sender.superview?.superview as? PlaceTypeCell,
            let placeType = cell.placeType
            else { return }
        
        removePlaces()
        mapVC?.panelDelegate.lastPanelPosition = nil
        switch placeType {
        case .event:
            mapVC?.mapDelegate.getPlaces(placeType: placeType, dataType: EventsResult.self)
        default:
            mapVC?.mapDelegate.getPlaces(placeType: placeType, dataType: GreenSpacesResult.self)
        }
    }
    
    /// Removes the places frome the previous search
    private func removePlaces() {
        places.removeAll()
        tableView.reloadData()
        guard let mapVC = mapVC else { return }
        mapVC.mapView.removeAnnotations(mapVC.mapView.annotations)
        mapVC.mapView.removeOverlays(mapVC.mapView.overlays)
    }
}

// MARK: - UICollectionViewDelegate
extension ListViewController: UICollectionViewDelegateFlowLayout {
    
    /// Asks the delegate for the size of the specified item’s cell
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let divisor = CGFloat(integerLiteral: PlaceType.allCases.count)
        return CGSize(width: view.frame.width / divisor, height: collectionView.frame.height)
    }

    /// Asks the delegate for the spacing between successive rows or columns of a section
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

// MARK: - UITableViewDataSource
extension ListViewController: UITableViewDataSource {
    
    /// Tells the data source to return the number of rows in a given section of a table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    /// Asks the data source for a cell to insert in a particular location of the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.identifier, for: indexPath) as? PlaceCell
            else { return UITableViewCell() }
        
        let place = places[indexPath.row]
        cell.place = place
        return cell
    }
    
    /// Updates the table view with new row
    private func updateTableView(_ oldValue: [Place]) {
        let numberOfPlaces = places.count
        guard numberOfPlaces > oldValue.count else { return }
        tableView.insertRows(at: [IndexPath(item: numberOfPlaces-1, section: 0)], with: .none)
    }
}

// MARK: - UITableViewDelegate
extension ListViewController: UITableViewDelegate {
    
    /// Tells the delegate that the specified row is now selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PlaceCell else { return }
        cell.isSelected = false
        mapVC?.state = .placeDetail(place: cell.place)
    }
}
