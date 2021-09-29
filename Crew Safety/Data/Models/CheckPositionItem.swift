//
//  CheckPositionItem.swift
//  Crew Safety
//
//  Created by Maximilian Alexander on 9/26/21.
//

import Foundation
import DittoSwift

enum CheckPositionItemStatus: Int, CaseIterable, Identifiable {
    case none = 0
    case good = 1
    case bad = 2

    var id: Int {
        return self.rawValue
    }

    var friendlyName: String {
        switch self {
        case .bad:
            return "bad"
        case .good:
            return "good"
        case .none:
            return "none"
        }
    }
}

enum CheckStyle: String, CaseIterable {
    case square = "square"
    case circle = "circle"
    case triangle = "triangle"
}


struct CheckPositionItem {
    var _id: String
    var checkPositionId: String
    var title: String
    var details: String
    var status: CheckPositionItemStatus
    var style: CheckStyle

    init(document: DittoDocument) {
        self._id = document["_id"].stringValue
        self.title = document["title"].stringValue
        self.checkPositionId = document["checkPositionId"].stringValue
        self.details = document["details"].stringValue
        self.status = CheckPositionItemStatus(rawValue: document["status"].intValue) ?? .none
        self.style = CheckStyle(rawValue: document["style"].stringValue) ?? .square
    }
}
