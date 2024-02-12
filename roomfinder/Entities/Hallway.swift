//
//  Hallway.swift
//  roomfinder
//
//  Created by Pascal Köchli on 01.02.2024.
//

import Foundation

struct Hallway: Identifiable, Hashable{
    let start: CGPoint
    let end: CGPoint
    let id = UUID()
    init (start: CGPoint, end: CGPoint){
        self.start = start; 
        self.end = end;
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id);
    }
    //var length: CGFloat { DistanceFormula(from: start, to: end) } /// calculate length
}
