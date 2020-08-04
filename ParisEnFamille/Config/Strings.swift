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
    static let directions = "Itinéraire"
    static let address = "Adresse"
    static let free = "Gratuit"
    static let payable = "Payant"
    static let onReservation = "sur réservation"
    
    // MARK: Event
    static let date = "Date"
    static let from = "Du"
    static let to = "au"
    static let description = "Description"
    static let access = "Accès"
    static let contact = "Contact"
    
    // MARK: Greenspace
    static let surface = "Surface"
    static let horticulturalSurface = "Surface horticole"
    static let fence = "Cloture"
    static let open24H = "Ouvert 24h/24"
    static let yes = "Oui"
    static let not = "Non"
    static let openingYear = "Année d'ouverture"
    static let undisclosed = "Indisponible"
    static let unavailable = "Indisponible"
    
    // MARK: Placetype
    static let activity = "Animation"
    static let conference = "Conférence"
    static let reading = "Lecture"
    static let games = "Jeux"
    static let otherAnimation = "Autres"
    
    static let education = "Education"
    static let workshop = "Atelier"
    static let practicum = "Stage"
    
    static let exhibit = "Exposition"
    static let contemporary = "Art Contemporain"
    static let fineArts = "Beaux-Arts"
    static let design = "Design / Mode"
    static let history = "Histoire"
    static let illustration = "Illustration"
    static let photography = "Photographie"
    static let science = "Sciences"
    static let streetArt = "Street-art"
    static let otherExhibit = "Autres"
    
    static let ramble = "Randonnée"
    static let visit = "Visite"
    static let park = "Parc"
    static let garden = "Jardin"
    static let promenade = "Promenade"
    
    static let all = "Tous"
    
    // MARK: Cluster
    static let places = "lieux"
}

// MARK: - Errors
extension Strings {
    static let url = "L'URL de la requête n'a pas pu être générée"
    static let server = "Mauvaise réponse"
    static let error = "erreur"
    static let noData = "La requête n'a renvoyé aucune donnée"
    static let decoding = "Le décodage des données a échoué"
    static let emptyData = "Aucun lieu trouvé"
}

// MARK: - Alerts
extension Strings {
    static let locationDisabled = "Services de localisation désactivés"
    static let turnOnLocation = "Veuillez activer les services de localisation pour voir votre position sur la carte."
    
    static let locationDenied = "Localisation non permise"
    static let allowLocation = "Veuillez autoriser \(Bundle.main.name) à accéder à votre position si vous souhaitez voir votre position sur la carte."
    
    static let locationUnavailable = "Localisation indisponible"
    static let checkSettings = "Veuillez vérifier les paramètres de votre appareil si des restrictions sont activées."
    
    static let settings = "Paramètres"
    static let cancel = "Annuler"
}
