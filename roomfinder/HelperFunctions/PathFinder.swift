//
//  PathFinder.swift
//  roomfinder
//
//  Created by Pascal Köchli on 12.02.2024.
//

import Foundation
import CoreGraphics

class PathFinder {    
    func constructGraph(hallways: [Hallway], rooms: [Room]) -> [Node] {
        var nodes = [CGPoint: Node]()
        
        // Create nodes for all unique points (hallway starts/ends and room entrances)
        for hallway in hallways {
            nodes[hallway.start] = Node(point: hallway.start, name:hallway.name + " Start")
            nodes[hallway.end] = Node(point: hallway.end, name:hallway.name + " End")
        }
        
        for room in rooms {
            let roomNode = Node(point: room.entrancePoint, name: room.name)
            nodes[room.entrancePoint] = roomNode // Ensure room nodes are added to the graph
            
            for hallway in hallways {
                if isPointOnLine(room.entrancePoint, startOfLine: hallway.start, endOfLine: hallway.end) {
                    // Connect room to hallway start
                    if let startNode = nodes[hallway.start] {
                        let edgeToStart = Edge(from: roomNode, to: startNode, weight: distance(from: room.entrancePoint, to: hallway.start))
                        roomNode.edges.append(edgeToStart)
                        
                        let edgeFromStart = Edge(from: startNode, to: roomNode, weight: edgeToStart.weight)
                        startNode.edges.append(edgeFromStart)
                    }
                    
                    // Connect room to hallway end
                    if let endNode = nodes[hallway.end] {
                        let edgeToEnd = Edge(from: roomNode, to: endNode, weight: distance(from: room.entrancePoint, to: hallway.end))
                        roomNode.edges.append(edgeToEnd)
                        
                        let edgeFromEnd = Edge(from: endNode, to: roomNode, weight: edgeToEnd.weight)
                        endNode.edges.append(edgeFromEnd)
                    }
                    
                    //Connect room to other rooms on same hallway
                    for otherRoom in rooms {
                        if isPointOnLine(otherRoom.entrancePoint, startOfLine: hallway.start, endOfLine: hallway.end){
                            let otherRoomNode = Node(point: otherRoom.entrancePoint, name: otherRoom.name)
                            if (nodes.keys.contains(otherRoom.entrancePoint) == false){
                                nodes[otherRoom.entrancePoint] = otherRoomNode // Ensure room nodes are added to the graph
                            }
                            
                            let edgeToStartRoom = Edge(from: roomNode, to: otherRoomNode, weight: distance(from: roomNode.point, to: otherRoomNode.point))
                            roomNode.edges.append(edgeToStartRoom)
                            
                            let edgeToOtherRoom = Edge(from: otherRoomNode, to: roomNode, weight: edgeToStartRoom.weight)
                            otherRoomNode.edges.append(edgeToOtherRoom)
                        }
                    }
                    
                }
                
            }
        }
        
        // Create edges for hallways
        for hallway in hallways {
            if let fromNode = nodes[hallway.start], let toNode = nodes[hallway.end] {
                let edge = Edge(from: fromNode, to: toNode, weight: distance(from: hallway.start, to: hallway.end))
                fromNode.edges.append(edge)
                // Assuming bi-directional movement
                let reverseEdge = Edge(from: toNode, to: fromNode, weight: edge.weight)
                toNode.edges.append(reverseEdge)
            }
        }
        
        return Array(nodes.values)
    }
    
    func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return hypot(to.x - from.x, to.y - from.y)
    }
    
    func dijkstra(nodes: [Node], start: Node, goal: Node) -> [Node] {
        var distances = [Node: CGFloat]()
        var previous = [Node: Node]()
        var queue = PriorityQueue<Node>(sort: { distances[$0, default: CGFloat.infinity] < distances[$1, default: CGFloat.infinity] })
        
        distances[start] = 0
        queue.enqueue(start)
        
        while let currentNode = queue.dequeue() {
            
            for edge in currentNode.edges {
                let distance = distances[currentNode, default: CGFloat.infinity] + edge.weight
                if distance < distances[edge.to, default: CGFloat.infinity] {
                    distances[edge.to] = distance
                    previous[edge.to] = currentNode
                    queue.enqueue(edge.to)
                }
            }
            
            if currentNode == goal {
                break
            }
            
        }
        
        return constructPath(from: previous, start: start, goal: goal)
    }
    
    func constructPath(from previous: [Node: Node], start: Node, goal: Node) -> [Node] {
        var path = [Node]()
        var current = goal
        
        while current != start {
            path.insert(current, at: 0)
            guard let next = previous[current] else { break }
            current = next
        }
        
        path.insert(start, at: 0)
        return path
    }
    
    func isPointOnLine(_ point: CGPoint, startOfLine: CGPoint, endOfLine: CGPoint) -> Bool {
        let crossProduct = (point.y - startOfLine.y) * (endOfLine.x - startOfLine.x) - (point.x - startOfLine.x) * (endOfLine.y - startOfLine.y)
        
        // Check if point is collinear with start and end
        if abs(crossProduct) > CGFloat.leastNonzeroMagnitude {
            return false
        }
        
        // Check if point is within the bounds of the line segment
        let dotProduct = (point.x - startOfLine.x) * (endOfLine.x - startOfLine.x) + (point.y - startOfLine.y) * (endOfLine.y - startOfLine.y)
        if dotProduct < 0 {
            return false
        }
        
        let squaredLength = (endOfLine.x - startOfLine.x) * (endOfLine.x - startOfLine.x) + (endOfLine.y - startOfLine.y) * (endOfLine.y - startOfLine.y)
        if dotProduct > squaredLength {
            return false
        }
        
        return true
    }
    
}
