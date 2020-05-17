//
//  BottomSheetViewController.swift
//  ParisNature
//
//  Created by co5ta on 14/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import UBottomSheet

class BottomSheetViewController: UIViewController, UITableViewDelegate {

    var sheetCoordinator: UBottomSheetCoordinator?
    var numbers = [0, 1, 2, 3, 4, 5]
    var tableView = UITableView()
    let cellIdentifier = "number"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setUpViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configure() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    /// Sets up the views
    private func setUpViews() {
        setUpTableView()
    }
    
    private func setUpTableView() {
        tableView.contentInsetAdjustmentBehavior = .never
    }
}

// MARK: - UITableViewDataSource
extension BottomSheetViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
            else { return UITableViewCell() }
        let number = numbers[indexPath.row]
        cell.textLabel?.text = "Item N°\(number)"
        return cell
    }
}

extension BottomSheetViewController: Draggable {
    
}
