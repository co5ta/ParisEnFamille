//
//  NukeImageLoader.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 13/03/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//
import Nuke

class NukeImageLoader: AnyImageLoader {
    func load(image: String, into imageView: UIImageView) {
        guard let url = URL(string: image) else { return }
        Nuke.loadImage(with: url, into: imageView)
    }
}

