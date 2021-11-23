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
        ditto = Ditto()
        if !isPreview {
            try! ditto.setLicenseToken("o2d1c2VyX2lkeCRmZWNlYTI1Ny04MWQ5LTQxMWMtYWZhMy1mYmQ1Nzk1NTQ0ZGZmZXhwaXJ5eBgyMDIyLTAzLTMxVDIxOjU5OjU5Ljg5NFppc2lnbmF0dXJleFhDV2laU2tzME9MSjF6clR6N1NpR0hNUjQ4WExvY3VxNHBvMTVIY3VKTmxJeEhSdFEyR3BkcjlZZG5JVXFFeFFRNGMvSkJGa1owNEFXZjJQN3diY1B2UT09")
            try! ditto.tryStartSync()
        }
        faker = Faker()
    }

    var checkPositions: AnyPublisher<[CheckPosition], Never> {
        return ditto.store["checkPositions"].findAll().publisher()
            .map({ (snapshot) -> [CheckPosition] in
                return snapshot.documents.compactMap({ try? $0.typed(as: CheckPosition.self).value })
            })
            .eraseToAnyPublisher()
    }

    var checkPositionItems: AnyPublisher<[CheckPositionItem], Never> {
        return ditto.store["checkPositionItems"].findAll().publisher()
            .map({ (snapshot) -> [CheckPositionItem] in
                return snapshot.documents.compactMap({ try? $0.typed(as: CheckPositionItem.self).value })
            })
            .eraseToAnyPublisher()
    }


    /// Gets checkPositionItems
    /// - Parameter checkPositionId: The checkPosition._id field
    func checkPositionItems(checkPositionId: String) ->  AnyPublisher<[CheckPositionItem], Never>  {
        return ditto
            .store["checkPositionItems"]
            .find("checkPositionId == $args.checkPositionId", args: ["checkPositionId": checkPositionId])
            .publisher()
            .map({ (docs, _) -> [CheckPositionItem] in
                return docs.compactMap({ doc in try? doc.typed(as: CheckPositionItem.self).value })
            })
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
                let _id = dictionary["_id"] as! String
                try! trx["checkPositions"].insert(dictionary, isDefault: true)
            })

            checkPositionItems?.forEach({ dictionary in
                let _id = dictionary["_id"] as! String
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
