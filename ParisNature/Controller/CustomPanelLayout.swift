//
//  CustomPanelLayout.swift
//  ParisNature
//
//  Created by co5ta on 19/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation
import FloatingPanel

class CustomPanelLayout: FloatingPanelLayout {
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        let screenSize = UIScreen.main.bounds.size
        guard let safeAreaInsets = UIApplication.shared.keyWindow?.safeAreaInsets else { return nil }
        switch position {
        case .full: return safeAreaInsets.top
        case .half: return screenSize.height * 0.35
        case .tip: return (screenSize.height / 6) - safeAreaInsets.bottom
        default: return nil // Or `case .hidden: return nil`
        }
    }
}
