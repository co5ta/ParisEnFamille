//
//  Strings.swift
//  ParisEnFamille
//
//  Created by co5ta on 03/07/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import Foundation

/// Enum of all static strings of the application
enum Strings {
    
    // MARK: Place
    static let directions = NSLocalizedString("Directions", comment: "")
    static let address = NSLocalizedString("Address", comment: "")
    static let free = NSLocalizedString("Free", comment: "")
    static let payable = NSLocalizedString("Payable", comment: "")
    static let onReservation = NSLocalizedString("on reservation", comment: "")
    
    // MARK: Event
    static let date = NSLocalizedString("Date", comment: "")
    static let from = NSLocalizedString("From", comment: "")
    static let to = NSLocalizedString("to", comment: "")
    static let description = NSLocalizedString("Description", comment: "")
    static let access = NSLocalizedString("Access", comment: "")
    static let contact = NSLocalizedString("Contact", comment: "")
    
    // MARK: Greenspace
    static let surface = NSLocalizedString("Surface", comment: "")
    static let horticulturalSurface = NSLocalizedString("Horticultural surface", comment: "")
    static let fence = NSLocalizedString("Fence", comment: "")
    static let open24H = NSLocalizedString("Open 24H a day", comment: "")
    static let yes = NSLocalizedString("Yes", comment: "")
    static let not = NSLocalizedString("No", comment: "")
    static let openingYear = NSLocalizedString("Opening year", comment: "")
    static let undisclosed = NSLocalizedString("Undisclosed", comment: "")
    static let unavailable = NSLocalizedString("Unavailable", comment: "")
    
    // MARK: Placetype
    static let activity = NSLocalizedString("Animation", comment: "")
    static let conference = NSLocalizedString("Conference", comment: "")
    static let reading = NSLocalizedString("Reading", comment: "")
    static let games = NSLocalizedString("Games", comment: "")
    static let otherAnimation = NSLocalizedString("Others", comment: "")
    
    static let education = NSLocalizedString("Education", comment: "")
    static let workshop = NSLocalizedString("Workshop", comment: "")
    static let practicum = NSLocalizedString("Practicum", comment: "")
    
    static let exhibit = NSLocalizedString("Exhibition", comment: "")
    static let contemporary = NSLocalizedString("Contemporary art", comment: "")
    static let fineArts = NSLocalizedString("Fine arts", comment: "")
    static let design = NSLocalizedString("Design / Fashion", comment: "")
    static let history = NSLocalizedString("History", comment: "")
    static let illustration = NSLocalizedString("Illustration", comment: "")
    static let photography = NSLocalizedString("Photography", comment: "")
    static let science = NSLocalizedString("Science", comment: "")
    static let streetArt = NSLocalizedString("Street-art", comment: "")
    static let otherExhibit = NSLocalizedString("Others", comment: "")
    
    static let ramble = NSLocalizedString("Ramble", comment: "")
    static let visit = NSLocalizedString("Visit", comment: "")
    static let park = NSLocalizedString("Park", comment: "")
    static let garden = NSLocalizedString("Garden", comment: "")
    static let promenade = NSLocalizedString("Promenade", comment: "")
    
    static let all = NSLocalizedString("All", comment: "")
    
    // MARK: Cluster
    static let places = NSLocalizedString("places", comment: "")
}

// MARK: - Errors
extension Strings {
    static let url = NSLocalizedString("The request URL couldn't be generate", comment: "")
    static let server = NSLocalizedString("Bad response", comment: "")
    static let error = NSLocalizedString("error", comment: "")
    static let noData = NSLocalizedString("The request didn't return any data", comment: "")
    static let decoding = NSLocalizedString("The data decoding failed", comment: "")
    static let emptyData = NSLocalizedString("No place founded", comment: "")
}

// MARK: - Alerts
extension Strings {
    static let locationDisabled = NSLocalizedString("Location services disabled", comment: "")
    static let turnOnLocation = NSLocalizedString("Please turn on the Location Services to see your position on the map.", comment: "")
    
    static let locationDenied = NSLocalizedString("Location denied", comment: "")
    static let allowLocation = NSLocalizedString("Please allow \(Bundle.main.name) to access your location if you want to see your position on the map.", comment: "")
    
    static let locationUnavailable = NSLocalizedString("Location unavailable", comment: "")
    static let checkSettings = NSLocalizedString("Please check in your device settings if any restrictions are enabled.", comment: "")
    
    static let settings = NSLocalizedString("Settings", comment: "")
    static let cancel = NSLocalizedString("Cancel", comment: "")
}
