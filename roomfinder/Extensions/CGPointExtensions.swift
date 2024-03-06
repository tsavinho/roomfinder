//
//  CGPointExtensions.swift
//  roomfinder
//
//  Created by Pascal Köchli on 15.02.2024.
//

import Foundation
import CoreGraphics

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }
}

extension CGPoint : Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(x)
        hasher.combine(y)
    }
}

extension CGPoint: Comparable {
    public static func < (lhs: CGPoint, rhs: CGPoint) -> Bool {
        if lhs.x != rhs.x {
            return lhs.x < rhs.x
        } else {
            return lhs.y < rhs.y
        }
    }
}
