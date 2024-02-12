//
//  Vertex.swift
//  roomfinder
//
//  Created by Pascal Köchli on 01.02.2024.
//

import Foundation

class Vertex : Equatable {
    let point: CGPoint
    var distance = CGFloat.infinity
    var touchingHallways = [Hallway]()
    
    var visited = false
    var previousHallway: Hallway?
    
    init(point: CGPoint){self.point = point}
    static func == (l: Vertex, r:Vertex) -> Bool{return l === r}
}

struct Route {
    var distance: CGFloat
    var path: [Vertex]
}
