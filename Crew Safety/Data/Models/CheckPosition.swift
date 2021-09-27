//
//  CheckPosition.swift
//  Crew Safety
//
//  Created by Maximilian Alexander on 9/26/21.
//

import Foundation
import DittoSwift

struct CheckPosition {
    var _id: String
    var title: String

    init(document: DittoDocument) {
        self._id = document["_id"].stringValue
        self.title = document["title"].stringValue
    }
}
