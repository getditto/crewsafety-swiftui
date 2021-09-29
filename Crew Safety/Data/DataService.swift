//
//  DataService.swift
//  Crew Safety
//
//  Created by Maximilian Alexander on 9/26/21.
//

import Foundation
import DittoSwift
import Combine
import CombineDitto
import Fakery

class DataService {

    static let shared = DataService()

    let ditto: Ditto
    let faker: Faker

    private init() {

        /// Checks if the current runtime is in the SwiftUI preview simulator
        let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"

        let identity = DittoIdentity.development(appID: isPreview ? "live.ditto.crew-safety-preview" : "live.ditto.crew-safety")
        ditto = Ditto(identity: identity)

        try! ditto.setLicenseToken("o2d1c2VyX2lkdFVzZXI6IG1heEBkaXR0by5saXZlZmV4cGlyeXgeMjAyMS0xMC0wNFQwNToxNzo0OC4yODQwMjg2MTlaaXNpZ25hdHVyZXhYSUZZc3NtT1hxUEdadFFVRzJhaWRTRnA1R0pUdlRGc0pPRnZlRWJpUEEzSnZxS1Iwc003NldhUUFKb0dBYTdKS1lsY2RKOGkvS1UySG05TDlFd1Y4K0E9PQ==")
        try! ditto.tryStartSync()
        faker = Faker()
    }

    var checkPositions: AnyPublisher<[CheckPosition], Never> {
        return ditto.store["checkPositions"].findAll().publisher()
            .map({ snapshot in return snapshot.documents.map({ CheckPosition(document: $0) }) })
            .eraseToAnyPublisher()
    }

    var checkPositionItems: AnyPublisher<[CheckPositionItem], Never> {
        return ditto.store["checkPositionItems"].findAll().publisher()
            .map({ snapshot in return snapshot.documents.map({ CheckPositionItem(document: $0) }) })
            .eraseToAnyPublisher()
    }


    /// Gets checkPositionItems
    /// - Parameter checkPositionId: The checkPosition._id field
    func checkPositionItems(checkPositionId: String) ->  AnyPublisher<[CheckPositionItem], Never>  {
        return ditto
            .store["checkPositionItems"]
            .find("checkPositionId == $args.checkPositionId", args: ["checkPositionId": checkPositionId])
            .publisher()
            .map({ snapshot in return snapshot.documents.map({ CheckPositionItem(document: $0) }) })
            .eraseToAnyPublisher()
    }

    func changeStatusFor(checkPositionItemIds: [String], status: CheckPositionItemStatus) {

        ditto.store.write { trx in
            checkPositionItemIds.forEach { _id in
                trx["checkPositionItems"].findByID(_id)
                    .update({ mutableDoc in
                        mutableDoc?["status"].set(status.rawValue)
                    })
            }
        }
    }


    /// Here we simulate the joins with Combine's `combineLatest` function. This observes two events and gives you a handler
    /// with the latest values of each event
    var checkPositionWithItems: AnyPublisher<[CheckPositionWithItems], Never> {
        return checkPositions.combineLatest(checkPositionItems)
            .map { positions, items in
                var withItems = [CheckPositionWithItems]()
                for position in positions {
                    let items = items.filter({ $0.checkPositionId == position._id })
                    withItems.append(CheckPositionWithItems(checkPosition: position, checkPositionItems: items))
                }
                return withItems
            }
            .eraseToAnyPublisher()
    }


    func bootstrapWithFakeData() {

        let checkPositions = readLocalJSONFile(forName: "fake-check-positions")
        let checkPositionItems = readLocalJSONFile(forName: "fake-check-position-items")

        ditto.store.write { trx in
            checkPositions?.forEach({ dictionary in
                try! trx["checkPositions"].insert(dictionary, isDefault: true)
            })

            checkPositionItems?.forEach({ dictionary in
                try! trx["checkPositionItems"].insert(dictionary, isDefault: true)
            })
        }
    }

    func readLocalJSONFile(forName name: String) -> [[String: Any]]? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                let arrayOfDictionaries = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
                return arrayOfDictionaries
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }

}
