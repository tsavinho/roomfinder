//
//  HelperFunctions.swift
//  roomfinder
//
//  Created by Pascal Köchli on 01.02.2024.
//

import Foundation
/*
func ShortestRouteFromVertices(vertices: [Vertex], start: CGPoint, end: CGPoint) -> Route? {
    /// use built-in `first(where:)` procedure to get vertex at point
    print(start.x)
    let startVertex = vertices.first(where: { $0.point == start })!
    let endVertex = vertices.first(where: { $0.point == end })!
    
    for vertex in vertices { vertex.visited = false; vertex.distance = CGFloat.infinity }
    var verticesToVisit: [Vertex] = [startVertex]
    startVertex.distance = 0 /// set the first vertex's distance to 0
    
    while verticesToVisit.isEmpty == false {
        /// inside `verticesToVisit`, use vertex with smallest distance
        let currentVisitingVertex = verticesToVisit.min(by: { a, b in a.distance < b.distance })!
        if currentVisitingVertex == endVertex { /// if vertex is at destination, done!
            var path = [currentVisitingVertex]
            func getPreviousVertex(currentVertex: Vertex) { /// recursive procedure to trace path backwards
                if let previousHallway = currentVertex.previousHallway {
                    let previousVertex = vertices.first(where: { $0.point == previousHallway.start })!
                    path.insert(previousVertex, at: 0) /// insert previous vertex at beginning of list
                    getPreviousVertex(currentVertex: previousVertex)
                }
            }
            getPreviousVertex(currentVertex: currentVisitingVertex)
            return Route(distance: currentVisitingVertex.distance, path: path) /// exit the `while` loop and return the shortest distance and path
        }
        
        /// set vertex to visited
        currentVisitingVertex.visited = true
        if let firstIndex = verticesToVisit.firstIndex(of: currentVisitingVertex) { verticesToVisit.remove(at: firstIndex) }
        
        for touchingHallway in currentVisitingVertex.touchingHallways { /// calculate distances of touching hallways
            let endVertex = vertices.first(where: { $0.point == touchingHallway.end })!
            if endVertex.visited == false {
                verticesToVisit.append(endVertex)
                let totalDistance = currentVisitingVertex.distance + touchingHallway.length
                if totalDistance < endVertex.distance { endVertex.distance = totalDistance; endVertex.previousHallway = touchingHallway }
            }
        }
    }
    
    return nil /// if no shortest path found, return nothing
}

/// get list of vertices (represents all possible paths) to a destination
func getVerticesTo(destinationPoint: CGPoint, hallways: [Hallway]) -> [Vertex] {
    /// ### 3B ii. (Row 2) - create `vertices` list from `hallways` list
    var vertices = [Vertex]()
    
    /// get and append a hallway's corresponding vertex to `vertices`, then append the hallway to the vertex's `touchingHallways`
    func configureVertexWith(hallway: Hallway) {
        var vertex: Vertex
        if let existingVertex = vertices.first(where: { $0.point == hallway.start }) {
            vertex = existingVertex /// prevent duplicates, get existing vertex in the `vertices` list
        } else {
            vertex = Vertex(point: hallway.start) /// create new vertex
            vertices.append(vertex) /// append to `vertices` list
        }
        vertex.touchingHallways.append(hallway)
    }
    
    var hallwaysCopy = hallways /// create mutable copy
    for i in hallwaysCopy.indices {
        if PointIsOnLine(lineStart: hallwaysCopy[i].start, lineEnd: hallwaysCopy[i].end, point: destinationPoint) {
            hallwaysCopy[i] = Hallway(start: hallwaysCopy[i].start, end: destinationPoint) /// replace full hallway with a portion
            configureVertexWith(hallway: Hallway(start: destinationPoint, end: destinationPoint)) /// final hallway, length of 0
        }
        configureVertexWith(hallway: hallwaysCopy[i])
    }
    
    return vertices
}

func PointIsOnLine(lineStart: CGPoint, lineEnd: CGPoint, point: CGPoint) -> Bool {
    let xAreSame = (point.x == lineStart.x && point.x == lineEnd.x)
    let yAreSame = (point.y == lineStart.y && point.y == lineEnd.y)
    
    if xAreSame {
        let maxY = max(lineStart.y, lineEnd.y)
        let minY = min(lineStart.y, lineEnd.y)
        if point.y <= maxY, point.y >= minY { /// compare Y coordinates
            return true
        }
    } else if yAreSame {
        let maxX = max(lineStart.x, lineEnd.x)
        let minX = min(lineStart.x, lineEnd.x)
        if point.x <= maxX, point.x >= minX { /// compare X coordinates
            return true
        }
    }
    return false /// not on the line
}

func shortestRouteBetween(start: Room, destination: Room, hallways: [Hallway]) -> Route? {
    /// **selection**
    let vertices = getVerticesTo(destinationPoint: destination.entrancePoint, hallways: hallways)
    if let shortestRoute = ShortestRouteFromVertices(vertices: vertices, start: start.entrancePoint, end: destination.entrancePoint) {
        return shortestRoute
    }

    return nil /// return nothing when if check fell through - no shortest path was found
}

public func DistanceFormula(from: CGPoint, to: CGPoint) -> CGFloat {
    let squaredDistance = (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    return sqrt(squaredDistance)
}
*/
