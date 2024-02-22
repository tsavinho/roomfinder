//
//  Room.swift
//  roomfinder
//
//  Created by Pascal Köchli on 01.02.2024.
//

import Foundation

struct Room: Identifiable, Hashable{
    var name: String
    var entrancePoint: CGPoint
    /// For future implementation
    var floor: Int
    let id = UUID()
    init(name: String, entrancePoint: CGPoint, floor: Int){
        self.name = name;
        self.entrancePoint = entrancePoint;
        self.floor = floor;
    }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func ==(lhs: Room, rhs: Room) -> Bool {
        return lhs.entrancePoint == rhs.entrancePoint
        }
}
