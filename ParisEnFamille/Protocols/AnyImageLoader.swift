//
//  AnyImageLoader.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 13/03/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//
import UIKit

protocol AnyImageLoader {
    func load(image: String, into imageView: UIImageView)
}
