//
//  ImageLoader.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 14/03/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import UIKit

class ImageLoader: AnyImageLoader {
    let loader: AnyImageLoader

    init(loader: AnyImageLoader = ImageLoader.defaultLoader) {
        self.loader = loader
    }

    func load(image: String, into imageView: UIImageView) {
        loader.load(image: image, into: imageView)
    }
}

extension ImageLoader {
    static let defaultLoader = NukeImageLoader()
}
