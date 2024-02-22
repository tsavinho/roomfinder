//
//  PulsatingCircle.swift
//  roomfinder
//
//  Created by Pascal Köchli on 15.02.2024.
//

import Foundation
import SwiftUI

struct PulsatingCircle: View {
    var positionPoint: CGPoint
    var backgroundColor: Color
    var size: CGFloat
    var squareSide: CGFloat
    var iconName: String
    
    @State private var animate = false
    
    init(positionPoint: CGPoint, backgroundColor: Color, size: CGFloat, iconName: String){
        self.positionPoint = positionPoint
        self.backgroundColor = backgroundColor
        self.size = size
        // https://stackoverflow.com/questions/70353762/add-a-circular-image-view-with-corner-radius-for-an-image-in-swiftui
        self.squareSide = 2.0.squareRoot() * size/2
        self.iconName = iconName
    }
    
    var body: some View {
        ZStack{
            Circle()
                .fill(backgroundColor).opacity(0.25)
                .frame(width: size * 2.5, height: size * 2.5)
                .scaleEffect(self.animate ? 1 : 0.5)
                .position(positionPoint)
            Circle()
                .fill(backgroundColor).opacity(0.5)
                .frame(width: size * 2, height: size * 2)
                .scaleEffect(self.animate ? 1 : 0.5)
                .position(positionPoint)
            Circle()
                .fill(backgroundColor).opacity(0.75)
                .frame(width: size * 1.5, height: size * 1.5)
                .scaleEffect(self.animate ? 1 : 0.5)
                .position(positionPoint)
            Circle()
                .fill(backgroundColor)
                .frame(width: size, height: size)
                .position(positionPoint)
            Image(systemName: iconName)
                .resizable()
                
                .frame(width: squareSide, height: squareSide)
                .position(positionPoint)
                .foregroundColor(Color.white)
            
        }
        .onAppear { withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
            self.animate = true
        }
        }
    }
}
