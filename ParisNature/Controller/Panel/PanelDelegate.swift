//
//  PanelDelegate.swift
//  ParisNature
//
//  Created by co5ta on 08/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit
import FloatingPanel

/// Delegate of the floating panels
class PanelDelegate: NSObject {
    
    /// Map view controller
    weak var mapVC: MapViewController?
    /// Last position of the list panel before its concealing
    var lastPanelPosition: FloatingPanelPosition?
}

// MARK: - FloatingPanelControllerDelegate
extension PanelDelegate: FloatingPanelControllerDelegate {
    
    /// Defines which floating panel to use
    // swiftlint:disable identifier_name
    func floatingPanel(_ vc: FloatingPanelController,
                       layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        
        return vc == (mapVC?.detailPanel) ? DetailPanelLayout() : ListPanelLayout()
    }
    
    /// Actions to execute before a panel will move to a new position
    // swiftlint:disable identifier_name
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        if vc == mapVC?.listPanel, mapVC?.listPanel.position == FloatingPanelPosition.hidden {
            mapVC?.listVC.listView.isHidden = false
        }
    }
    
    /// Actions to execute after a panel reach a new position
    // swiftlint:disable identifier_name
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController,
                                     withVelocity velocity: CGPoint,
                                     targetPosition: FloatingPanelPosition) {
        
        if vc == mapVC?.detailPanel, targetPosition == .hidden {
            guard let lastPanelPosition = lastPanelPosition else { return }
            mapVC?.listPanel.move(to: lastPanelPosition, animated: true)
        } else if vc == mapVC?.listPanel, targetPosition == .hidden {
            mapVC?.listVC.listView.isHidden = true
        }
    }
}
