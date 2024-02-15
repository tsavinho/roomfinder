//
//  Node.swift
//  roomfinder
//
//  Created by Pascal Köchli on 15.02.2024.
//

import Foundation

class Node: Hashable{
    var point: CGPoint
    var edges: [Edge] = []
    var name: String
    
    init(point: CGPoint, name:String) {
        self.point = point;
        self.name = name;
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.point == rhs.point
    }
    
    public static func < (lhs: Node, rhs: Node) -> Bool {
        if lhs.point.x != rhs.point.x {
            return lhs.point.x < rhs.point.x
        } else {
            return lhs.point.y < rhs.point.y
        }
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(point.x)
        hasher.combine(point.y)
    }
}
