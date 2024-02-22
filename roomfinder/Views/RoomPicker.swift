//
//  RoomPicker.swift
//  roomfinder
//
//  Created by Pascal Köchli on 22.02.2024.
//

import SwiftUI

struct RoomPicker: View {
    @Binding var room: String
    @State var sortedRooms: [Room]
    @State var roomLabel: String
    @State var color: Color
    @State var backgroundColor = Color.white
    @State var borderColor = Color.white

    
    var body: some View {
        Picker(roomLabel, selection:$room){
            Text(LocalizedStringKey("selectARoom")).tag("")
            ForEach(sortedRooms, id: \.self){item in
                Text(item.name).tag(item.name)
            }
        }
        .frame(width:150)
        .padding(5)
        .background(backgroundColor)
        .cornerRadius(10)
        .shadow(radius: 5)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(borderColor, lineWidth: 2)
        )
        .accentColor(color)
    }
}
