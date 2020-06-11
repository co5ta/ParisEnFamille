//
//  ListView.swift
//  ParisNature
//
//  Created by co5ta on 11/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

class ListView: UIView {

    var visualEffectView: UIVisualEffectView!
    var collectionView: UICollectionView!
    var imagesButton = [UIButton]()
    let tableView = UITableView()
    var loadingView = UIActivityIndicatorView()
    var errorView = ErrorView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

extension ListView {
    
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
        addSubview(visualEffectView)
    }
    
    /// Sets up the collection view
    private func setUpCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.register(PlaceTypeCollectionViewCell.self, forCellWithReuseIdentifier: PlaceTypeCollectionViewCell.identifier)
        addSubview(collectionView)
    }
    
    /// Sets up the table view
    private func setUpTableView() {
        tableView.register(PlaceTableViewCell.self, forCellReuseIdentifier: PlaceTableViewCell.identifier)
        tableView.backgroundColor = .clear
        addSubview(tableView)
    }
    
    /// Sets up the loading view
    private func setUpLoadingView() {
        loadingView.startAnimating()
        loadingView.style = .gray
        loadingView.isHidden = true
        addSubview(loadingView)
    }
    
    /// Sets up error view
    private func setUpErrorView() {
        errorView.isHidden = true
        addSubview(errorView)
    }
}

// MARK: - Constraints
extension ListView {
    
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
            visualEffectView.topAnchor.constraint(equalTo: topAnchor),
            visualEffectView.leadingAnchor.constraint(equalTo: leadingAnchor),
            visualEffectView.trailingAnchor.constraint(equalTo: trailingAnchor),
            visualEffectView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// Constrains collection view
    private func constrainCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    /// Constrains table view
    private func constrainTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// Constrains loading view
    private func constrainLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingView.topAnchor.constraint(equalToSystemSpacingBelow: collectionView.bottomAnchor, multiplier: 5)
        ])
    }
    
    private func constrainErrorView() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
