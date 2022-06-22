//
//  ListEventsViewController.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 27/02/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import UIKit

protocol ListEventsDisplayLogic {
    func displayEvents(viewModel: ListEvents.FetchEvents.ViewModel)
}

class ListEventsViewController: UIViewController, ListEventsDisplayLogic {
    var interactor: ListEventsBusinessLogic?
    var events: [ListEvents.FetchEvents.ViewModel.EventItem] = []
    private var dataSource: DataSource?

    @IBOutlet weak var collectionView: UICollectionView!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    private func setup() {
        let viewController = self
        let interactor = ListEventsInteractor()
        let presenter = ListEventsPresenter()
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    override func viewDidLoad() {
        collectionView.register(UINib(nibName: "EventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EventCell")
        collectionView.collectionViewLayout = createCompositionalLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchEvents()
    }

    private func fetchEvents() {
        interactor?.fetchEventItems()
    }

    func displayEvents(viewModel: ListEvents.FetchEvents.ViewModel) {
        events = viewModel.events
        dataSource = makeDataSource()
        applySnapshot()
    }
}

// MARK: - UICollectionViewDiffableDataSource

private extension ListEventsViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListEvents.FetchEvents.ViewModel.EventItem>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ListEvents.FetchEvents.ViewModel.EventItem>

    enum Section {
        case main
    }
    
    enum Constants {
        static let cellSpacing: CGFloat = 20
    }

    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, event in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as? EventCollectionViewCell
            cell?.configure(with: event)
            return cell
        }
        return dataSource
    }

    func applySnapshot(animate: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(events)
        dataSource?.apply(snapshot, animatingDifferences: animate)
    }

    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(1))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = Constants.cellSpacing
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
