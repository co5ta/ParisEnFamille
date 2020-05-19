//
//  PlacesViewController.swift
//  ParisNature
//
//  Created by co5ta on 16/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class PlacesViewController: UIViewController {
    
    var visualEffectView: UIVisualEffectView!
    var collectionView: UICollectionView!
}

// MARK: - Lifecycle
extension PlacesViewController {
    
    /// Called after the controller's view is loaded into memory
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        constrainViews()
        configure()
    }
}

// MARK: - Setup
extension PlacesViewController {
    
    private func configure() {
        view.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func setUpViews() {
        setUpBackgroundView()
        setUpCollectionView()
    }
    
    private func setUpBackgroundView() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.backgroundColor = .white
        visualEffectView.alpha = 0.85
        view.addSubview(visualEffectView)
    }
    
    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(PlaceTypeCell.self, forCellWithReuseIdentifier: PlaceTypeCell.identifier)
        visualEffectView.contentView.addSubview(collectionView)
    }
}

// MARK: - Constraints
extension PlacesViewController {
    
    private func constrainViews() {
        constrainBackgroundView()
        constrainCollectionView()
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
            collectionView.topAnchor.constraint(equalToSystemSpacingBelow: visualEffectView.topAnchor, multiplier: 3),
            collectionView.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor),
//            collectionView.heightAnchor.constraint(equalToConstant: 110)
            collectionView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.width / 3)
        ])
//        collectionView.backgroundColor = .blue
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
            else { fatalError("no place type cell") }
        cell.placeType = PlaceType.allCases[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension PlacesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: view.frame.width / 4, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}
