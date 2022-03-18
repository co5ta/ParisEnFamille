//
//  ListEventsModels.swift
//  ParisEnFamille
//
//  Created by Costa Monzili on 03/03/2022.
//  Copyright © 2022 Co5ta. All rights reserved.
//

import Foundation
import MapKit

enum ListEvents {
    enum FetchEvents {
        struct Request {}
        struct Response {
            var events: [Event]
        }
        struct ViewModel {
            var events: [ViewModel.Event] = []
            struct Event: Hashable {
                let uuid: UUID
                let title: String
                let intro: String
                let descriptionText: String
                let coverUrl: String
            }
        }
    }
}
