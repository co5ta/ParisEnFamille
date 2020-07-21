//
//  Strings.swift
//  ParisNature
//
//  Created by co5ta on 03/07/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

//import Foundation

/// Enum of all static strings of the application
enum Strings {
    
    // MARK: Place
    static let directions = "Directions"
    static let address = "Address"
    static let free = "Free"
    static let payable = "Payable"
    static let onReservation = "on reservation"
    
    // MARK: Event
    static let date = "Date"
    static let description = "Description"
    static let access = "Access"
    static let contact = "Contact"
    
    // MARK: Greenspace
    static let surface = "Surface"
    static let horticulturalSurface = "Horticultural surface"
    static let fence = "Fence"
    static let open24H = "Open 24H a day"
    static let yes = "Yes"
    static let not = "No"
    static let openingYear = "Opening year"
    static let undisclosed = "Undisclosed"
    static let unavailable = "Unavailable"
    
    // MARK: Placetype
    static let activity = "Leisure"
    static let conference = "Conference"
    static let reading = "Reading"
    static let games = "Games"
    static let otherAnimation = "Others"
    
    static let education = "Education"
    static let workshop = "Workshop"
    static let practicum = "Practicum"
    
    static let exhibit = "Exhibition"
    static let contemporary = "Contemporary"
    static let fineArts = "Fine arts"
    static let design = "Design"
    static let history = "History"
    static let illustration = "Illustration"
    static let photography = "Photography"
    static let science = "Science"
    static let streetArt = "Street-art"
    static let otherExhibit = "Others"
    
    static let ramble = "Ramble"
    static let visit = "Visit"
    static let park = "Park"
    static let garden = "Garden"
    static let promenade = "Promenade"
    
    static let all = "All"
}

// MARK: - Errors
extension Strings {
    static let url = "The request URL couldn't be generate"
    static let server = "Bad response"
    static let error = "error"
    static let noData = "The request didn't return any data"
    static let decoding = "The data decoding failed"
    static let emptyData = "No place founded"
}

// MARK: - Alerts
extension Strings {
    static let locationDisabled = (
        title: "Location services disabled",
        message: "Please turn on the Location Services to display your position on the map"
    )
    
    static let locationDenied = (
        title: "Location denied",
        message: "Please allow 'Paris Nature' to access your location to display your position on the map"
    )
    
    static let locationUnavailable = (
        title: "Location unavailable",
        message: "Please check in Settings, maybe your location is restricted"
    )
    
    static let settings = "Settings"
    static let cancel = "Cancel"
}
