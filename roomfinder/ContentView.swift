//
//  ContentView.swift
//  roomfinder
//
//  Created by Pascal Köchli on 25.01.2024.
//  The code in this project was inspired by https://github.com/aheze/PathMapper.
//

import SwiftUI

struct ContentView: View {
    @State private var startingRoom: String = ""
    @State private var endingRoom: String = ""
    @State private var showStartingRoomDropdown = false
    @State private var isTapped = false
    @State private var mapPathDrawnPercentage = CGFloat(0)
    @State private var startingRoomObject = Room(name: "No room", entrancePoint:  CGPoint(x: 0, y:0), floor:1)
    @State private var endingRoomObject = Room(name: "No room", entrancePoint:  CGPoint(x: 0, y:0), floor:1)
    @State private var shortestPath: [Node] = []
    
    let hallways = [
        ///Vertical hallways
        Hallway(start: CGPoint(x:0.17,y:0.595), end: CGPoint(x:0.17, y:0.863), name:"5.1 Links"), //5.1 left
        Hallway(start: CGPoint(x:0.491,y:0.595), end: CGPoint(x:0.491, y:0.863), name:"5.1 Rechts"), //5.1 right
        Hallway(start: CGPoint(x:0.33,y:0.595), end: CGPoint(x:0.33, y:0.315), name:"Passarelle"), //Passarelle
        Hallway(start: CGPoint(x:0.33,y:0.315), end: CGPoint(x:0.33, y:0.145), name:"6.1 links"), //6.1 left
        Hallway(start: CGPoint(x:0.81,y:0.145), end: CGPoint(x:0.81, y:0.315), name:"6.1 rechts"), //6.1 right
        Hallway(start: CGPoint(x:0.865,y:0.31), end: CGPoint(x:0.865, y:0.315), name:"6.1 connector rechts"), //6.1 bottom connector
        
        ///Horizontal hallways
        Hallway(start: CGPoint(x:0.17, y:0.863), end: CGPoint(x:0.491, y:0.863), name:"5.1 unten"), //5.1 bottom
        Hallway(start: CGPoint(x:0.17, y:0.595), end: CGPoint(x:0.33, y:0.595), name:"5.1 oben links"), //5.1 top left
        Hallway(start: CGPoint(x:0.33, y:0.595), end: CGPoint(x:0.491, y:0.595), name:"5.1 oben rechts"), //5.1 top right
        Hallway(start: CGPoint(x:0.33, y:0.315), end: CGPoint(x:0.81, y:0.315), name:"6.1 unten"), //6.1 bottom
        Hallway(start: CGPoint(x:0.33, y:0.145), end: CGPoint(x:0.81, y:0.145), name:"6.1 oben"), //6.1 top
        Hallway(start: CGPoint(x:0.81, y:0.315), end: CGPoint(x:0.865, y:0.315), name:"6.1 connector unten") //6.1 bottom connector
    ]
    
    let rooms = [
        Room(name: "5.1H12", entrancePoint:  CGPoint(x: 0.17, y:0.795), floor:1),
        Room(name: "5.1H14", entrancePoint:  CGPoint(x: 0.17, y:0.745), floor:1),
        Room(name: "5.1H16", entrancePoint:  CGPoint(x: 0.17, y:0.695), floor:1),
        Room(name: "5.1H19", entrancePoint:  CGPoint(x: 0.17, y:0.645), floor:1),
        Room(name: "5.1D02", entrancePoint:  CGPoint(x: 0.171, y:0.595), floor:1), //To make sure 5.1 oben links start works correctly
        Room(name: "5.1H03", entrancePoint:  CGPoint(x: 0.285, y:0.863), floor:1),
        Room(name: "5.1H01", entrancePoint:  CGPoint(x: 0.375, y:0.863), floor:1),
        Room(name: "5.1A17", entrancePoint:  CGPoint(x: 0.491, y:0.795), floor:1),
        Room(name: "5.1D11", entrancePoint:  CGPoint(x: 0.33, y:0.55), floor:1),
        Room(name: "6.1H01", entrancePoint:  CGPoint(x: 0.445, y:0.145), floor:1),
        Room(name: "6.1H03", entrancePoint:  CGPoint(x: 0.535, y:0.145), floor:1),
        Room(name: "6.1H05", entrancePoint:  CGPoint(x: 0.625, y:0.145), floor:1),
        Room(name: "6.1H07", entrancePoint:  CGPoint(x: 0.715, y:0.145), floor:1),
        Room(name: "6.1H13", entrancePoint:  CGPoint(x: 0.81, y:0.213), floor:1),
        Room(name: "6.1H15", entrancePoint:  CGPoint(x: 0.81, y:0.263), floor:1),
        Room(name: "6.1A03", entrancePoint:  CGPoint(x: 0.81, y:0.24), floor:1),
        Room(name: "6.1A06", entrancePoint:  CGPoint(x: 0.865, y:0.31), floor:1)
    ]
    
    var startingColor = Color.orange
    var endingColor = Color.red
    var routeColor = Color.blue
    var selectRoom = "selectARoom"
    var startingRoomLabel = "start"
    var endingRoomLabel = "destination"
    var startingIcon = "figure.walk"
    var endingIcon = "mappin"
    var noRoomString = "No room"
    var noRoom: Room
    
    let sortedRooms: [Room]
    let pathFinder: PathFinder
    let graph: [Node]
    
    init() {
        //Initialize the pathfinder construct so that the path can be found faster
        pathFinder = PathFinder()
        graph = pathFinder.constructGraph(hallways: hallways, rooms: rooms)
        sortedRooms = rooms.sorted{$0.name < $1.name}
        noRoom = Room(name: noRoomString, entrancePoint:  CGPoint(x: 0, y:0), floor:1)
    }
    
    var body: some View {
        VStack{
            FHNWNavigationBar()
            VStack {
                Spacer()
                Image("1_og_new")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        GeometryReader{ geometry in
                            Path { path in
                                if shortestPath.isEmpty == false {
                                    let firstPoint = shortestPath.first!
                                    path.move(to: ScaleCGPointWithGeometry(in: geometry, originalPoint: firstPoint.point))
                                    for node in shortestPath {
                                        if (node != firstPoint){
                                            path.addLine(to: ScaleCGPointWithGeometry(in: geometry, originalPoint: node.point))
                                        }
                                    }
                                }
                            }
                            .trim(from: 0, to: mapPathDrawnPercentage) /// animate path drawing
                            .stroke(routeColor, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .shadow(color: Color.black.opacity(0.3), radius: 3)
                            if startingRoomObject.name != noRoomString {
                                PulsatingCircle(positionPoint: ScaleCGPointWithGeometry(in: geometry, originalPoint: startingRoomObject.entrancePoint), backgroundColor: startingColor, size: 15, iconName: startingIcon)
                            }
                            if endingRoomObject.name != noRoomString{
                                PulsatingCircle(positionPoint: ScaleCGPointWithGeometry(in: geometry, originalPoint: endingRoomObject.entrancePoint), backgroundColor: endingColor, size: 15, iconName: endingIcon)
                            }
                        },
                        alignment: .topLeading
                    )
                Spacer()
            }
            .frame(maxHeight: .infinity)
            
            VStack{
                HStack{
                    HStack{
                        Spacer()
                        Label {
                            Text(LocalizedStringKey(startingRoomLabel))
                                .multilineTextAlignment(.center)
                        } icon: {
                            Image(systemName: startingIcon)
                                .foregroundColor(startingColor)
                        }
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        Label {
                            Text(LocalizedStringKey(endingRoomLabel))
                                .multilineTextAlignment(.leading)
                        } icon: {
                            Image(systemName: endingIcon)
                                .foregroundColor(endingColor)
                        }
                        Spacer()
                    }
                }
                .padding(.leading,10)
                .padding(.trailing, 10)
                
                HStack{
                    Spacer()
                    RoomPicker(room: $startingRoom, sortedRooms: sortedRooms, roomLabel: startingRoomLabel, color:Color.black, backgroundColor: Color(.systemGray6), borderColor: Color(.systemGray6))
                        .onChange(of: startingRoom){roomname in
                            let filteredRooms = rooms.filter{room in
                                if room.name == roomname {
                                    return true
                                }
                                return false
                            }
                            if (filteredRooms.count == 1){
                                startingRoomObject = filteredRooms[0]
                                if (endingRoomObject.name != noRoomString){
                                    let start = graph.first(where: {$0.point == startingRoomObject.entrancePoint})!
                                    let end = graph.first(where: {$0.point == endingRoomObject.entrancePoint})!
                                    let shortestPathFound =  pathFinder.dijkstra(nodes: graph, start: start, goal: end)
                                    if (shortestPathFound.count>0)
                                    {
                                        ResetPathForDrawing()
                                        withAnimation (.linear(duration:0.5)){
                                            shortestPath = shortestPathFound
                                            mapPathDrawnPercentage = 1
                                        }
                                    } else {
                                        shortestPath = []
                                    }
                                }
                            }
                            else {
                                startingRoomObject = noRoom
                                ResetPathForDrawing()
                            }
                        }
                    Spacer()
                    RoomPicker(room: $endingRoom, sortedRooms: sortedRooms, roomLabel: endingRoomLabel, color:Color.black, backgroundColor: Color(.systemGray6), borderColor: Color(.systemGray6))
                        .onChange(of: endingRoom) {roomname in
                            let filteredRooms = rooms.filter{room in
                                if room.name == roomname {
                                    return true
                                }
                                return false
                            }
                            if (filteredRooms.count == 1){
                                endingRoomObject = filteredRooms[0]
                                if (startingRoomObject.name != noRoomString){
                                    let start = graph.first(where: {$0.point == startingRoomObject.entrancePoint})!
                                    let end = graph.first(where: {$0.point == endingRoomObject.entrancePoint})!
                                    let shortestPathFound =  pathFinder.dijkstra(nodes: graph, start: start, goal: end)
                                    shortestPath = []
                                    if (shortestPathFound.count>0)
                                    {
                                        ResetPathForDrawing()
                                        withAnimation (.linear(duration:0.5)){
                                            shortestPath = shortestPathFound
                                            mapPathDrawnPercentage = 1
                                        }
                                    } else {
                                        shortestPath = []
                                    }
                                }
                            }
                            else{
                                endingRoomObject = noRoom
                                ResetPathForDrawing()
                            }
                        }
                    Spacer()
                }
                .padding(.bottom, 10)
            }
        }
        .pickerStyle(.menu)
    }
    
    func ResetPathForDrawing(){
        shortestPath = []
        mapPathDrawnPercentage = 0
    }
    
    func ScaleCGPointWithGeometry(in geometry: GeometryProxy, originalPoint: CGPoint) -> CGPoint{
        return CGPoint(
            x: originalPoint.x * geometry.size.width,
            y: originalPoint.y * geometry.size.height
        )
    }
}

#Preview {
    ContentView()
        .environment(\.locale, .init(identifier: "de"))
}
