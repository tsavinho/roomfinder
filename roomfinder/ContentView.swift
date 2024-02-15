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
    @State private var startingRoomObject = Room(name: "No room", entrancePoint:  CGPoint(x: 0, y:0))
    @State private var endingRoomObject = Room(name: "No room", entrancePoint:  CGPoint(x: 0, y:0))
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
        Room(name: "5.1H12", entrancePoint:  CGPoint(x: 0.17, y:0.795)),
        Room(name: "5.1H14", entrancePoint:  CGPoint(x: 0.17, y:0.745)),
        Room(name: "5.1H16", entrancePoint:  CGPoint(x: 0.17, y:0.695)),
        Room(name: "5.1H19", entrancePoint:  CGPoint(x: 0.17, y:0.645)),
        Room(name: "5.1D02", entrancePoint:  CGPoint(x: 0.171, y:0.595)), //To make sure 5.1 oben links start works correctly
        Room(name: "5.1H03", entrancePoint:  CGPoint(x: 0.285, y:0.863)),
        Room(name: "5.1H01", entrancePoint:  CGPoint(x: 0.375, y:0.863)),
        Room(name: "5.1A17", entrancePoint:  CGPoint(x: 0.491, y:0.795)),
        Room(name: "5.1D11", entrancePoint:  CGPoint(x: 0.33, y:0.55)),
        Room(name: "6.1H01", entrancePoint:  CGPoint(x: 0.445, y:0.145)),
        Room(name: "6.1H03", entrancePoint:  CGPoint(x: 0.535, y:0.145)),
        Room(name: "6.1H05", entrancePoint:  CGPoint(x: 0.625, y:0.145)),
        Room(name: "6.1H07", entrancePoint:  CGPoint(x: 0.715, y:0.145)),
        Room(name: "6.1H13", entrancePoint:  CGPoint(x: 0.81, y:0.213)),
        Room(name: "6.1H15", entrancePoint:  CGPoint(x: 0.81, y:0.263)),
        Room(name: "6.1A03", entrancePoint:  CGPoint(x: 0.81, y:0.24)),
        Room(name: "6.1A06", entrancePoint:  CGPoint(x: 0.865, y:0.31))
    ]
    
    var startingColor = Color.green
    var endingColor = Color.red
    var selectRoom = "Select a room..."
    var startingRoomLabel = "Start:"
    var endingRoomLabel = "Destination:"
    
    let sortedRooms: [Room]
    let pathFinder: PathFinder
    let graph: [Node]

    init() {
        //Initialize the pathfinder construct so that the path can be found faster
        pathFinder = PathFinder()
        graph = pathFinder.constructGraph(hallways: hallways, rooms: rooms)
        sortedRooms = rooms.sorted{$0.name < $1.name}
    }
    
    var body: some View {
        VStack{
            FHNWNavigationBar()
                .frame(height:50)
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
                            .stroke(Color.blue, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                            .shadow(color: Color.black.opacity(0.3), radius: 3)
                            if shortestPath.isEmpty == false {
                                let firstPoint = shortestPath.first!
                                let lastPoint = shortestPath.last!
                                PulsatingCircle(positionPoint: ScaleCGPointWithGeometry(in: geometry, originalPoint: firstPoint.point), backgroundColor: startingColor, size: 10)
                                PulsatingCircle(positionPoint: ScaleCGPointWithGeometry(in: geometry, originalPoint: lastPoint.point), backgroundColor: endingColor, size: 10)
                            }
                        },
                        alignment: .topLeading
                    )
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
            
            VStack{
                HStack{
                    Text(startingRoomLabel)
                    Spacer()
                    Picker(startingRoomLabel,selection: $startingRoom){
                        Text(selectRoom).tag("")
                        ForEach(sortedRooms, id: \.self){item in
                            Text(item.name).tag(item.name)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(startingColor, lineWidth: 2)
                    )
                    .accentColor(startingColor)
                    .onChange(of: startingRoom){roomname in
                        let filteredRooms = rooms.filter{room in
                            if room.name == roomname {
                                return true
                            }
                            return false
                        }
                        if (filteredRooms.count == 1){
                            startingRoomObject = filteredRooms[0]
                            if (endingRoomObject.name != "No room"){
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
                                    print("No path found from start to end")
                                    shortestPath = []
                                }
                            }
                        }
                        else {
                            startingRoomObject = Room(name: "No room", entrancePoint:  CGPoint(x: 0, y:0))
                            ResetPathForDrawing()
                        }
                    }
                }
                .padding(.leading,10)
                .padding(.trailing, 10)
                
                HStack{
                    Text(endingRoomLabel)
                    Spacer()
                    Picker(endingRoomLabel, selection:$endingRoom){
                        Text(selectRoom).tag("")
                        ForEach(sortedRooms, id: \.self){item in
                            Text(item.name).tag(item.name)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(endingColor, lineWidth: 2)
                    )
                    .accentColor(endingColor)
                    .onChange(of: endingRoom) {roomname in
                        let filteredRooms = rooms.filter{room in
                            if room.name == roomname {
                                return true
                            }
                            return false
                        }
                        if (filteredRooms.count == 1){
                            endingRoomObject = filteredRooms[0]
                            if (startingRoomObject.name != "No room"){
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
                                    print("No path found from start to end")
                                    
                                }
                            }
                        }
                        else{
                            endingRoomObject = Room(name: "No room", entrancePoint:  CGPoint(x: 0, y:0))
                            ResetPathForDrawing()
                        }
                    }
                }
                .padding(.leading,10)
                .padding(.trailing, 10)
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
}
