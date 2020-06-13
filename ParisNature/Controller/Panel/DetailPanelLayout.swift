//
//  DetailPanelLayout.swift
//  ParisNature
//
//  Created by co5ta on 12/06/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import FloatingPanel

/// Configures the detail floating panel
class DetailPanelLayout: FloatingPanelLayout {
    
    /// The positions supported by the panel
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.full, .half, .hidden]
    }
    
    /// The initial position of the panel
    var initialPosition: FloatingPanelPosition {
        return .hidden
    }
    
    /// Defines the available positions of the floating panel
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        let screenSize = UIScreen.main.bounds.size
        guard let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets else { return nil }
        switch position {
        case .full: return safeAreaInsets.top
        case .half: return screenSize.height * 0.3
        default: return nil
        }
    }
}
