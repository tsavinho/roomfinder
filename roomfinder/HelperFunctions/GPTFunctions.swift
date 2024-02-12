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

struct PathPoint: Comparable {
    var point: CGPoint
    var distance: CGFloat
    
    static func < (lhs: PathPoint, rhs: PathPoint) -> Bool {
        lhs.distance < rhs.distance
    }
}

class PathFinder {
    let hallways: [Hallway]
    let rooms: [Room]
    
    init(hallways: [Hallway], rooms: [Room]) {
        self.hallways = hallways
        self.rooms = rooms
    }
    
    func findShortestPath(from start: CGPoint, to end: CGPoint) -> [CGPoint] {
        var distances: [CGPoint: CGFloat] = [:]
        var previous: [CGPoint: CGPoint] = [:]
        var queue = PriorityQueue<PathPoint>(sort:{
            $0.distance < $1.distance
        })
        
        for hallway in hallways {
            distances[hallway.start] = .infinity
            distances[hallway.end] = .infinity
            previous[hallway.start] = nil
            previous[hallway.end] = nil
            queue.enqueue(PathPoint(point: hallway.start, distance: .infinity))
            queue.enqueue(PathPoint(point: hallway.end, distance: .infinity))
        }
        for room in rooms {
            distances[room.entrancePoint] = .infinity
            previous[room.entrancePoint] = nil
            queue.enqueue(PathPoint(point: room.entrancePoint, distance: .infinity))
        }
        
        distances[start] = 0
        queue.enqueue(PathPoint(point: start, distance: 0))
        
        while let current = queue.dequeue()?.point {
            if current == end {
                var path = [end]
                var current = end
                while let prev = previous[current] {
                    path.append(prev)
                    current = prev
                }
                return path.reversed()
            }
            
            for neighbor in neighbors(of: current) {
                let alt = distances[current]! + distance(from: current, to: neighbor)
                if alt < distances[neighbor]! {
                    distances[neighbor] = alt
                    previous[neighbor] = current
                    queue.enqueue(PathPoint(point: neighbor, distance: alt))
                }
            }
        }
        
        return []
    }
    
    private func distance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(pow(from.x - to.x, 2) + pow(from.y - to.y, 2))
    }
    
    private func neighbors(of point: CGPoint) -> [CGPoint] {
        var result = [CGPoint]()
            
            for hallway in hallways {
                if hallway.start == point {
                    result.append(hallway.end)
                } else if hallway.end == point {
                    result.append(hallway.start)
                } else if point.isOnLine(start: hallway.start, end: hallway.end) {
                    result.append(point.isClosest(to: hallway.start, and: hallway.end))
                }
            }
            
            for room in rooms {
                if room.entrancePoint == point {
                    result.append(contentsOf: hallways.map { $0.start })
                    result.append(contentsOf: hallways.map { $0.end })
                }
            }
            
            return result
    }
}
