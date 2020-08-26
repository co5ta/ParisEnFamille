//
//  ParisEnFamilleTests.swift
//  ParisEnFamilleTests
//
//  Created by co5ta on 08/05/2020.
//  Copyright © 2020 Co5ta. All rights reserved.
//

import XCTest
import MapKit
@testable import ParisEnFamille

/// Tests of the Model and Service modules
class ParisEnFamilleTests: XCTestCase {
    
    /// Url session for testing
    var session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    /// Response expectation
    let expectation = XCTestExpectation(description: "response")
}

// MARK: - Tests
extension ParisEnFamilleTests {
    
    /// Test bad response of the type from the API
    func testBadResponseType() {
        let response = FakeAPI.badResponseType
        let data = FakeAPI.getJson(name: "events")
        MockURLProtocol.requestHandler = { request in
            return (response, data)
        }
        NetworkService(session: session).getPlaces(placeType: .activity, dataType: EventsResult.self) { (result) in
            switch result {
            case .success:
                XCTFail("This request must not success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.server(nil))
                self.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    /// Test bad response of code returned by the API
    func testBadResponseCode() {
        let response = FakeAPI.responseCode500
        let data = FakeAPI.getJson(name: "events")
        MockURLProtocol.requestHandler = { request in
            return (response, data)
        }
        NetworkService(session: session).getPlaces(placeType: .activity, dataType: EventsResult.self) { (result) in
            switch result {
            case .success:
                XCTFail("This request must not success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.server(response))
                self.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }

    /// Test bad data returned by the API
    func testBadData() {
        let response = FakeAPI.responseCode200
        MockURLProtocol.requestHandler = { request in
            return (response, FakeAPI.badData)
        }
        NetworkService(session: session).getPlaces(placeType: .activity, dataType: EventsResult.self) { (result) in
            switch result {
            case .success:
                XCTFail("This request must not success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.decoding(nil))
                self.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    /// Test empty data returned by the API
    func testNoResult() {
        let response = FakeAPI.responseCode200
        let data = FakeAPI.getJson(name: "empty")
        MockURLProtocol.requestHandler = { request in
            return (response, data)
        }
        NetworkService(session: session).getPlaces(placeType: .activity, dataType: EventsResult.self) { (result) in
            switch result {
            case .failure:
                XCTFail("This request must not fail")
            case .success(let result):
                XCTAssertEqual(result.records.count, 0)
                self.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    /// Test list of Events  returned by the API
    func testEvents() {
        let response = FakeAPI.responseCode200
        let dataType = EventsResult.self
        let data = FakeAPI.getJson(name: "events")
        MockURLProtocol.requestHandler = { request in
            return (response, data)
        }
        NetworkService(session: session).getPlaces(placeType: .activity, dataType: dataType) { (eventsResult) in
            switch eventsResult {
            case .failure:
                XCTFail("This request must not fail")
            case .success(let result):
                XCTAssertEqual(result.records.count, 10)
                let event = result.records.first!
                XCTAssertEqual(event.title!, "Ateliers de percussions corporelles et vocales")
                XCTAssertEqual(event.coordinate.latitude, 48.838014408275136)
                XCTAssertEqual(event.coordinate.longitude, 2.347723928386006)
                XCTAssertEqual(event.address, "38 rue Broca \n75005 Paris")
                XCTAssertEqual(event.dateDescription, "Du 20 janvier 2020 au 31 décembre 2022 : <br />lundi, mardi, mercredi, jeudi, vendredi, samedi, dimanche de 14h à 15h<br />")
                XCTAssertEqual(event.leadText, "Pianiste professionnel, compositeur, music-producer et pédagogue, j'aime partager ma passion et transmettre mon savoir-faire. J'aime faire révéler à d'autres leur inspiration musicale.")
                XCTAssertEqual(event.descriptionText, "<p>Les percussions corporelles qu'est-ce que c'est ?</p><p>Taper dans ses mains et sur son corps, taper avec les pieds, utiliser sa voix pour chanter, faire des onomatopées ou encore imiter un instrument de musique.</p><p>Il s'agit d'apprendre à faire de la musique en utilisant comme règle numéro 1 : Le rythme.</p><p>On peut alors faire de la musique sans avoir de notions de solfège, ni savoir jouer d'un instrument.</p><p>Le plaisir est ici de jouer, improviser, tout en apprenant à jouer en rythme, savoir écouter les autres, et laisser libre cours à son imagination. IL s'agit aussi de trouver le groove, cette façon qu'on a de sentir le rythme qui est contagieux pour celui qui l'écoute.</p><p>Cela favorise l'expression de façon d'une façon plus directe sans passer par des connaissances théoriques. Ici le ressenti, le corps, l'écoute de soi et des autres sont les maitres mots.</p><p>Ouvert à tout le monde, les débutants voulant faire improviser, les danseurs, les plus avancés, et ceux qui veulent progresser en rythme.</p><p>Qui suis-je ? </p><p>Je suis pianiste, arrangeur, compositeur et pédagogue. </p><p>J'ai enseigné au Conservatoire de Vincennes en piano jazz, au Conservatoire de Meaux en section jazz et musiques actuelles, l'école de musique de Dammarie-les-lys et en cours particuliers.</p><p>j'ai coaché des chanteuses sur leur placement rythmique, l'aisance scénique, et l'intérprétation.</p><p>DEM Jazz du CRR d’Annecy et de Chambéry en Jazz et diplômé du Centre des Musiques Didier Lockwood (meilleur école de jazz en France) mention très bien. J’ai étudié auprès de grands noms du jazz : Didier Lockwood, Benoit Sourisse, Bojan Z, Pierre de Bethmann, Baptiste Trotignon, Pierre Drevet, Pierre Perchaud, Stéphane Guillaume, Linley Marthe, Vince Mendoza (Björk), Mike Stern, Louis Winsberg, Mike Moreno, Aaron Goldberg…</p><p>J’ai étudié le piano classique auprès de Gisèle Magnan anciennement professeur au CNSM de Paris, et Karen Daniau.</p><p>Les divers artistes avec qui j’ai eu la chance de collaborer : Les Coquettes (spectacle d’humour), Natalia Doco (chanson argentine), Seemone (finaliste pour le concours de l’Eurovision), Anthony Jambon Group (jazz), Baptiste Herbin, Benjamin Henocq, Hollydays (pop electro), Dam’n’co, Eva Slongo (violon jazz), Patxi Garat, Yseult. Mon parcours est éclectique : jazz, pop, soul, funk, gospel, spectacle d’humour, chansons latines, variété. Connaissant bien les rouages de styles musicaux divers, je me consacre à la transmission de ce savoir faire.</p><p>Après 4 années de tendinites chroniques et ne pouvant pas exercer mon métier librement, j’ai dû trouver des solutions par un travail de rééducation et une nouvelle méthode que j’enseigne.</p><p>Mes différentes collaborations ainsi que ma recherche personnelle sont une source d’inspiration pour transmettre ma passion de la musique à mes élèves en adaptant ma pédagogie à chacun.</p><p>Mon album en trio intitulé « The Path Up » en 2017 est sorti avec en invité Pierre Perchaud et qui suscite de très bonne critiques.</p>")
                XCTAssertEqual(event.access, [Strings.payable, Strings.onReservation])
                XCTAssertEqual(event.priceDetail, "25€ par personne")
                XCTAssertEqual(event.contactName, "FOLO.me")
                XCTAssertEqual(event.accessLink, "https://folo.me/activities/5e248ae357c4df103326e27f")
                XCTAssertEqual(event.contactUrl, "https://folo.me/")
                XCTAssertEqual(event.contactPhone, "0184800301")
                XCTAssertEqual(event.contactMail, "laia@folo.me")
                let localeDates = ["fr": "Du 20 janvier 2020 au 31 décembre 2022",
                                   "en": "From January 20, 2020 to December 31, 2022"]
                XCTAssertEqual(event.subheading, localeDates[Locale.current.languageCode!])
                self.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
    
    /// Test list of greenspaces returned by the API
    func testGreenSpaces() {
        let response = FakeAPI.responseCode200
        let data = FakeAPI.getJson(name: "greenspaces")
        MockURLProtocol.requestHandler = { request in
            return (response, data)
        }
        NetworkService(session: session).getPlaces(placeType: .park, dataType: GreenSpacesResult.self) { (greenspacesResult) in
            switch greenspacesResult {
            case .failure:
                XCTFail("This request must not fail")
            case .success(let result):
                XCTAssertEqual(result.records.count, 10)
                let greenspace = result.records.first!
                XCTAssertEqual(greenspace.title, "Pelouse Place Du General Catroux-Sud (Massif Tb)")
                XCTAssertEqual(greenspace.address, "1 place Du General Catroux \n75017 Paris")
                XCTAssertEqual(greenspace.geom.type, Geom.GeomType.multiPolygon)
                XCTAssertEqual(greenspace.department, "75")
                XCTAssertEqual(greenspace.fence, Strings.yes)
                XCTAssertEqual(greenspace.horticulture, nil)
                XCTAssertEqual(greenspace.open24h, Strings.not)
                XCTAssertEqual(greenspace.openingYear, "1862")
                XCTAssertEqual(greenspace.subheading, "1 place Du General Catroux")
                XCTAssertEqual(greenspace.surface, 1612)
                XCTAssertEqual(greenspace.subheading, "1 place Du General Catroux")
                self.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 1)
    }
}
