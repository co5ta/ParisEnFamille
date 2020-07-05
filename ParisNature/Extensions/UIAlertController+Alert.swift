//
//  UIAlertController+Alert.swift
//  ParisNature
//
//  Created by co5ta on 03/07/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import UIKit

extension UIAlertController {
    
    /// Generates a plain alert with a confirmation button
    static func settingsAlert(title: String, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Strings.cancel, style: .default))
        alert.addAction(UIAlertAction(title: Strings.settings, style: .cancel) { _ in
            guard let settings = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settings)
        })
        return alert
    }
}
