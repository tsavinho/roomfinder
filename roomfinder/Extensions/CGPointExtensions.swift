//
//  CGPointExtensions.swift
//  roomfinder
//
//  Created by Pascal Köchli on 15.02.2024.
//

import Foundation
import CoreGraphics

extension CGPoint {
    func isOnLine(start: CGPoint, end: CGPoint) -> Bool {
        let dxc = self.x - start.x
        let dyc = self.y - start.y
        let dxl = end.x - start.x
        let dyl = end.y - start.y
        let cross = dxc * dyl - dyc * dxl
        return cross == 0
    }
    
    func isClosest(to point1: CGPoint, and point2: CGPoint) -> CGPoint {
        let d1 = point2.distance(to: self)
        let d2 = point2.distance(to: point1)
        return d1 < d2 ? point2 : point1
    }
    
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
