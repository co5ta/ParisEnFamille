//
//  Bundle+AppName.swift
//  ParisEnFamille
//
//  Created by co5ta on 24/07/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

extension Bundle {
    
    /// Name of the Bundle
    var name: String {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
            ?? object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? "the application"
    }
}
