//
//  CustomPanelLayout.swift
//  ParisNature
//
//  Created by co5ta on 19/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import FloatingPanel

/// Configures the list floating panel
class ListPanelLayout: FloatingPanelLayout {
    
    /// The initial position of the panel
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    /// Defines the available positions of the floating panel
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        guard let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets else { return nil }
        switch position {
        case .full: return safeAreaInsets.top
        case .half: return Config.screenSize.height * 0.35
        case .tip: return (Config.screenSize.height / 7) - (safeAreaInsets.bottom * 1.25)
        case .hidden: return nil
        }
    }
}
