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
    var interactor: ListEventsInteractor?
    var events: [ListEvents.FetchEvents.ViewModel.Event] = []
    var dataSource: DataSource?

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
        self.interactor = ListEventsInteractor()
        self.interactor?.presenter = ListEventsPresenter()
        self.interactor?.presenter?.viewController = self
    }

    override func viewDidLoad() {
        collectionView.register(UINib(nibName: "EventCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EventCell")
        collectionView.collectionViewLayout = createCompositionalLayout()
        fetchEvents()
    }

    private func fetchEvents() {
        interactor?.fetchEvents()
    }

    func displayEvents(viewModel: ListEvents.FetchEvents.ViewModel) {
        events = viewModel.events
        dataSource = makeDataSource()
        applySnapshot()
    }
}


// MARK: - UICollectionViewDiffableDataSource

extension ListEventsViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ListEvents.FetchEvents.ViewModel.Event>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ListEvents.FetchEvents.ViewModel.Event>

    enum Section {
        case main
    }

    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, event in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventCell", for: indexPath) as? EventCollectionViewCell
            cell?.configure(with: event)
            return cell
        }
        return dataSource
    }

    private func applySnapshot(animate: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(events)
        dataSource?.apply(snapshot, animatingDifferences: animate)
    }

    func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
      let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
      let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

      let section = NSCollectionLayoutSection(group: group)

      let layout = UICollectionViewCompositionalLayout(section: section)
      return layout
    }
}
