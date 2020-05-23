//
//  PlacesViewController.swift
//  ParisNature
//
//  Created by co5ta on 16/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {
    
    var mapVC: MapViewController?
    var visualEffectView: UIVisualEffectView!
    var collectionView: UICollectionView!
    var imagesButton = [UIButton]()
    let tableView = UITableView()
    var places = [Place]() { didSet {updateTableView(oldValue)} }
    var loadingView = UIActivityIndicatorView()
    var state = State.neutral { didSet {adjustViews()} }
}

// MARK: - Lifecycle
extension PlacesViewController {
    
    /// Called after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        configure()
    }
}

// MARK: - Setup
extension PlacesViewController {
    
    private func configure() {
        view.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        tableView.dataSource = self
    }
    
    private func setUpViews() {
        setUpBackgroundView()
        setUpCollectionView()
        setUpTableView()
        setUpLoadingView()
        constrainViews()
    }
    
    private func setUpBackgroundView() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.backgroundColor = .white
        visualEffectView.alpha = 0.75
        view.addSubview(visualEffectView)
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(PlaceTypeCell.self, forCellWithReuseIdentifier: PlaceTypeCell.identifier)
        view.addSubview(collectionView)
    }
    
    private func setUpTableView() {
        tableView.register(PlaceCell.self, forCellReuseIdentifier: PlaceCell.identifier)
        tableView.backgroundColor = .clear
        view.addSubview(tableView)
    }
    
    private func setUpLoadingView() {
        loadingView.color = .systemGreen
        loadingView.hidesWhenStopped = true
        view.addSubview(loadingView)
    }
}

// MARK: - Constraints
extension PlacesViewController {
    
    private func constrainViews() {
        constrainBackgroundView()
        constrainCollectionView()
//        constrainSeparator()
        constrainTableView()
        constrainLoadingView()
    }
    
    private func constrainBackgroundView() {
        visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            visualEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func constrainCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: view.frame.width / 4)
        ])
    }
    
    private func constrainTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func constrainLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.topAnchor.constraint(equalToSystemSpacingBelow: collectionView.bottomAnchor, multiplier: 5)
        ])
    }
}

// MARK: - State
extension PlacesViewController {
    private func adjustViews() {
        switch state {
        case .loading:
            displayLoading()
        case .ready:
            displayTableView()
        case .empty:
            displayError()
        case .neutral:
            break
        }
    }
    
    private func displayLoading() {
        mapVC?.floatingPanelController.move(to: .half, animated: true)
        loadingView.startAnimating()
        tableView.isHidden = true
    }
    
    private func displayTableView() {
        mapVC?.floatingPanelController.move(to: .half, animated: true)
        loadingView.stopAnimating()
        tableView.isHidden = false
    }
    
    private func displayError() {
        mapVC?.floatingPanelController.move(to: .half, animated: true)
        loadingView.stopAnimating()
        tableView.isHidden = true
    }
}

// MARK: - UICollectionViewDataSource
extension PlacesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PlaceType.allCases.count
    }
    
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
    
    @objc
    private func imageButtonTapped(sender: UIButton) {
        guard sender.isSelected == false else { return }
        imagesButton.forEach { $0.isSelected = ($0 != sender) ? false : true }
        guard let cell = sender.superview?.superview as? PlaceTypeCell, let placeType = cell.placeType else { return }
        switch placeType {
        case .greenery:
            mapVC?.getPlaces(placeType: placeType, dataType: GreenSpacesResult.self)
        case .event:
            print("Fetch events")
        case .market:
            print("Fetch markets")
        }
    }
}

// MARK: - UICollectionViewDelegate
extension PlacesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let divisor = CGFloat(integerLiteral: PlaceType.allCases.count)
        return CGSize(width: view.frame.width / divisor, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

extension PlacesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlaceCell.identifier, for: indexPath) as? PlaceCell
            else { return UITableViewCell() }
        
        let place = places[indexPath.row]
        cell.place = place
        return cell
    }
}

extension PlacesViewController {
    
    private func updateTableView(_ oldValue: [Place]) {
        let numberOfPlaces = places.count
        guard numberOfPlaces > oldValue.count else { return }
        tableView.insertRows(at: [IndexPath(item: numberOfPlaces-1, section: 0)], with: .none)
    }
}
