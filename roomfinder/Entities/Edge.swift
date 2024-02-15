//
//  Edge.swift
//  roomfinder
//
//  Created by Pascal Köchli on 15.02.2024.
//

import Foundation

class Edge {
    var from: Node
    var to: Node
    var weight: CGFloat
    
    init(from: Node, to: Node, weight: CGFloat) {
        self.from = from
        self.to = to
        self.weight = weight
    }
}
