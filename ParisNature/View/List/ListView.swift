//
//  ListView.swift
//  ParisNature
//
//  Created by co5ta on 11/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

/// Template of the list screen
class ListView: UIView {

    /// Blur background
    var visualEffectView: UIVisualEffectView!
    /// Collection view of place types
    var collectionView: UICollectionView!
    /// Cluster title
    let clusterTitleLabel = UILabel()
    /// Underline of the cluster title
    let underlineView = UIView()
    /// Table view of places
    let tableView = UITableView()
    /// Loading indicator
    var loadingView = UIActivityIndicatorView()
    /// Error view
    var errorView = ErrorView()
    /// Cancel button
    let cancelButton = CancelButton()
    /// Collection view of place subtypes
    var subTypeCollectionView: UICollectionView!
    
    /// Init from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    /// Init from storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUpViews()
    }
}

// MARK: - Setup
extension ListView {
    
    /// Sets up the views
    private func setUpViews() {
        setUpVisualEffectView()
        setUpCollectionView()
        setUpClusterTitleLabel()
        setUpUnderlineView()
        setUpTableView()
        setUpLoadingView()
        setUpErrorView()
        setUpCancelButton()
//        setUpSubTypeCollectionView()
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
        collectionView.register(PlaceTypeCell.self, forCellWithReuseIdentifier: PlaceTypeCell.identifier)
        addSubview(collectionView)
    }

    /// Sets up the cluster title label
    private func setUpClusterTitleLabel() {
        clusterTitleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle).bold()
        clusterTitleLabel.adjustsFontForContentSizeCategory = true
        clusterTitleLabel.adjustsFontSizeToFitWidth = true
        addSubview(clusterTitleLabel)
    }

    /// Sets up the underline view
    private func setUpUnderlineView() {
        underlineView.backgroundColor = .black
        addSubview(underlineView)
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
    
    /// Sets up the error view
    private func setUpErrorView() {
        errorView.isHidden = true
        addSubview(errorView)
    }
    
    /// Sets up the cancel button
    private func setUpCancelButton() {
        cancelButton.isHidden = true
        addSubview(cancelButton)
    }
    
    /// Sets up the collection view of categories
    private func setUpSubTypeCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.estimatedItemSize = CGSize(width: 1, height: 1)
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        subTypeCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        subTypeCollectionView.backgroundColor = .clear
        subTypeCollectionView.register(SubTypeCell.self, forCellWithReuseIdentifier: SubTypeCell.identifier)
        subTypeCollectionView.showsHorizontalScrollIndicator = false
        addSubview(subTypeCollectionView)
    }
}

// MARK: - Constraints
extension ListView {
    
    /// Constrains  views
    private func constrainViews() {
        constrainVisualEffectView()
        constrainCollectionView()
        constrainClusterTitleLabel()
        constrainUnderlineView()
        constrainTableView()
        constrainLoadingView()
        constrainErrorView()
        constrainCancelButton()
//        constrainSubTypeCollectionView()
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
        let height = Config.screenSize.width * 0.25
        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: height),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    /// Constrains cluster title label
    private func constrainClusterTitleLabel() {
        clusterTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clusterTitleLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 4),
            clusterTitleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
        ])
    }

    /// Constrains the underlineView
    private func constrainUnderlineView() {
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            underlineView.heightAnchor.constraint(equalToConstant: 3),
            underlineView.topAnchor.constraint(equalTo: clusterTitleLabel.bottomAnchor),
            underlineView.leadingAnchor.constraint(equalTo: clusterTitleLabel.leadingAnchor),
            underlineView.trailingAnchor.constraint(equalTo: clusterTitleLabel.trailingAnchor)
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
//            tableView.bottomAnchor.constraint(equalTo: subTypeCollectionView.topAnchor)
            
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
    
    /// Constrains the error view
    private func constrainErrorView() {
        errorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            errorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    /// Constrains the cancel button
    private func constrainCancelButton() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 25),
            cancelButton.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: cancelButton.trailingAnchor, multiplier: 2)
        ])
    }
        
    /// Constrains the subtype collection view
    private func constrainSubTypeCollectionView() {
        subTypeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        let height = Config.screenSize.height * 0.1
        NSLayoutConstraint.activate([
            subTypeCollectionView.heightAnchor.constraint(equalToConstant: height),
            subTypeCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subTypeCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            subTypeCollectionView.bottomAnchor.constraint(greaterThanOrEqualToSystemSpacingBelow: bottomAnchor, multiplier: 0)
        ])
    }
}
