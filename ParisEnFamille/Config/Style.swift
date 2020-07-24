//
//  Style.swift
//  ParisEnFamille
//
//  Created by co5ta on 01/07/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//
import UIKit

/// Enum of main colors used in the app
enum Style {
    
    /// The color for content layered on top of secondary backgrounds
    static var tertiarySystemBackground: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.tertiarySystemBackground
        } else {
            return UIColor.white
        }
    }
    
    /// The color for text labels that contain primary content
    static var label: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.label
        } else {
            return UIColor.black
        }
    }
    
    /// The color for text labels that contain secondary content
    static var secondarylabel: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.secondaryLabel
        } else {
            return UIColor.systemGray
        }
    }
    
    /// An overlay fill color for thin and small shape
    static var systemFill: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.systemFill
        } else {
            return appGray
        }
    }
    
    /// The color for thin borders or divider lines that allows some underlying content to be visible
    static var separator: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.separator
        } else {
            return appGray
        }
    }
    
    /// Custom gray color
    static var appGray: UIColor {
        UIColor(red: 0.819, green: 0.819, blue: 0.84, alpha: 1)
    }
    
    /// Blur effect used by the app
    static var appBlur: UIBlurEffect.Style {
        if #available(iOS 13.0, *) {
            return UIBlurEffect.Style.systemChromeMaterial
        } else {
            return UIBlurEffect.Style.extraLight
        }
    }
}
