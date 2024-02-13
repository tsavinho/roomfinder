//
//  GPTFunctions.swift
//  roomfinder
//
//  Created by Pascal Köchli on 12.02.2024.
//

import Foundation
import CoreGraphics

struct Graph {
    let rooms: [Room]
    let hallways: [Hallway]
}

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
                if isPoint(room.entrancePoint, onLineSegmentBetween: hallway.start, and: hallway.end) {
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
                print(edge.from.name)
                print(edge.to.name)
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
    
    func isPoint(_ point: CGPoint, onLineSegmentBetween start: CGPoint, and end: CGPoint) -> Bool {
        let crossProduct = (point.y - start.y) * (end.x - start.x) - (point.x - start.x) * (end.y - start.y)
        
        // Check if point is collinear with start and end
        if abs(crossProduct) > CGFloat.leastNonzeroMagnitude {
            return false
        }
        
        // Check if point is within the bounds of the line segment
        let dotProduct = (point.x - start.x) * (end.x - start.x) + (point.y - start.y) * (end.y - start.y)
        if dotProduct < 0 {
            return false
        }
        
        let squaredLength = (end.x - start.x) * (end.x - start.x) + (end.y - start.y) * (end.y - start.y)
        if dotProduct > squaredLength {
            return false
        }
        
        return true
    }
    
}
