//
//  CheckPositionWithItems.swift
//  Crew Safety
//
//  Created by Maximilian Alexander on 9/26/21.
//

import Foundation


/// This is a virtual struct that we use to simulate a SQL-like join

struct CheckPositionWithItems {
    var checkPosition: CheckPosition
    var checkPositionItems: [CheckPositionItem]

    var squareProgress: Float {
        let goodCount = checkPositionItems.filter({ $0.style == .square && $0.status == .good }).count
        let total = checkPositionItems.filter({ $0.style == .square}).count
        return Float(goodCount) / Float(total)
    }

    var circleProgress: Float {
        let goodCount = checkPositionItems.filter({ $0.style == .circle && $0.status == .good }).count
        let total = checkPositionItems.filter({ $0.style == .circle }).count
        return Float(goodCount) / Float(total)
    }

    var triangleProgress: Float {
        let goodCount = checkPositionItems.filter({ $0.style == .triangle && $0.status == .good }).count
        let total = checkPositionItems.filter({ $0.style == .triangle }).count
        return Float(goodCount) / Float(total)
    }
}
