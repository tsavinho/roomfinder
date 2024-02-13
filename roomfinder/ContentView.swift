//
//  ContentView.swift
//  roomfinder
//
//  Created by Pascal Köchli on 25.01.2024.
//

import SwiftUI

struct ContentView: View {
    @State var startingRoom: String = ""
    @State var endingRoom: String = ""
    @State var showStartingRoomDropdown = false
    @State var isTapped = false
    let hallways = [
        
        ///Vertical hallways
        Hallway(start: CGPoint(x:0.337,y:0.585), end: CGPoint(x:0.337, y:1.038), name:"5.1 Links"), //5.1 left
        Hallway(start: CGPoint(x:0.492,y:0.585), end: CGPoint(x:0.492, y:1.038), name:"5.1 Rechts"), //5.1 right
        Hallway(start: CGPoint(x:0.423,y:0.585), end: CGPoint(x:0.423, y:0.099), name:"Passarelle"), //Passarelle
        Hallway(start: CGPoint(x:0.423,y:0.099), end: CGPoint(x:0.423, y:-0.18), name:"6.1 links"), //6.1 left
        Hallway(start: CGPoint(x:0.655,y:-0.18), end: CGPoint(x:0.655, y:0.099), name:"6.1 rechts"), //6.1 right
        Hallway(start: CGPoint(x:0.681,y:-0.18), end: CGPoint(x:0.681, y:0.099), name:"6.1 connector rechts"), //6.1 bottom connector
        
        ///Horizontal hallways
        Hallway(start: CGPoint(x:0.337, y:1.038), end: CGPoint(x:0.492, y:1.038), name:"5.1 unten"), //5.1 bottom
        Hallway(start: CGPoint(x:0.337, y:0.585), end: CGPoint(x:0.423, y:0.585), name:"5.1 oben links"), //5.1 top left
        Hallway(start: CGPoint(x:0.423, y:0.585), end: CGPoint(x:0.492, y:0.585), name:"5.1 oben rechts"), //5.1 top right
        Hallway(start: CGPoint(x:0.423, y:0.099), end: CGPoint(x:0.655, y:0.099), name:"6.1 unten"), //6.1 bottom
        Hallway(start: CGPoint(x:0.423, y:-0.18), end: CGPoint(x:0.655, y:-0.18), name:"6.1 oben"), //6.1 top
        Hallway(start: CGPoint(x:0.655, y:-0.18), end: CGPoint(x:0.681, y:-0.18), name:"6.1 connector unten") //6.1 bottom connector
    ]
    
    let rooms = [
        Room(name: "5.1H12", entrancePoint:  CGPoint(x: 0.337, y:0.935)),
        Room(name: "5.1H14", entrancePoint:  CGPoint(x: 0.337, y:0.85)),
        Room(name: "5.1H16", entrancePoint:  CGPoint(x: 0.337, y:0.765)),
        Room(name: "5.1H19", entrancePoint:  CGPoint(x: 0.337, y:0.68)),
        Room(name: "5.1D02", entrancePoint:  CGPoint(x: 0.338, y:0.585)),
        
        Room(name: "5.1H03", entrancePoint:  CGPoint(x: 0.402, y:1.038)),
        Room(name: "5.1H01", entrancePoint:  CGPoint(x: 0.445, y:1.038)),
        Room(name: "5.1A17", entrancePoint:  CGPoint(x: 0.492, y:0.935)),
        Room(name: "5.1D11", entrancePoint:  CGPoint(x: 0.423, y:0.52)),
        Room(name: "6.1H01", entrancePoint:  CGPoint(x: 0.472, y:-0.18)),
        
        Room(name: "6.1H03", entrancePoint:  CGPoint(x: 0.5155, y:-0.18)),
        Room(name: "6.1H05", entrancePoint:  CGPoint(x: 0.559, y:-0.18)),
        Room(name: "6.1H07", entrancePoint:  CGPoint(x: 0.6025, y:-0.18)),
        Room(name: "6.1H13", entrancePoint:  CGPoint(x: 0.655, y:-0.07)),
        Room(name: "6.1H15", entrancePoint:  CGPoint(x: 0.655, y:0.015)),
        
        Room(name: "6.1A03", entrancePoint:  CGPoint(x: 0.655, y:-0.01)),
        Room(name: "6.1A06", entrancePoint:  CGPoint(x: 0.681, y:0.098))
    ]
    
    /*@State var resultDistance = CGFloat(0)
     @State var mapPathVertices = [Vertex]()
     @State var mapPathDrawnPercentage = CGFloat(0)*/
    
    @State var startingRoomObject = Room(name: "No room", entrancePoint:  CGPoint(x: 0, y:0))
    @State var endingRoomObject = Room(name: "No room", entrancePoint:  CGPoint(x: 0, y:0))
    
    let pathFinder: PathFinder
    let graph: [Node]
    @State var shortestPath: [Node] = []
    
    init() {
        pathFinder = PathFinder()
        graph = pathFinder.constructGraph(hallways: hallways, rooms: rooms)
    }
    
    var body: some View {
        
        VStack{
            customNavigationBar
            Spacer()
            Image("1_og")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.degrees(90))
                .overlay(
                    GeometryReader{ geometry in
                        
                        ForEach(rooms, id: \.self){item in
                            Circle()
                                .fill(Color.green)
                                .frame(width:10,height:10)
                                .position(
                                    x:geometry.size.width * item.entrancePoint.x,
                                    y:geometry.size.height * item.entrancePoint.y
                                )
                        }
                        /*ForEach(hallways, id: \.self){hallway in
                         Path {path in
                         path.move(to: CGPoint(x:hallway.start.x * geometry.size.width, y:hallway.start.y * geometry.size.height))
                         path.addLine(to: CGPoint(x:hallway.end.x * geometry.size.width, y:hallway.end.y * geometry.size.height))
                         }
                         .stroke(.blue, lineWidth:1)
                         }*/
                        Path { path in
                            if shortestPath.isEmpty == false {
                                let firstPoint = shortestPath.first!
                                path.move(to: CGPoint(x:firstPoint.point.x*geometry.size.width, y:firstPoint.point.y*geometry.size.height))
                                for node in shortestPath {
                                    if (node != firstPoint){
                                        path.addLine(to: CGPoint(x:node.point.x*geometry.size.width,y:node.point.y*geometry.size.height))
                                    }
                                }
                            }
                        }
                        //.trim(from: 0, to: mapPathDrawnPercentage) /// animate path drawing
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                        .shadow(color: Color.black.opacity(0.3), radius: 3)
                        
                    },
                    alignment: .topLeading
                )
            
            Spacer()
            
            VStack{
                HStack{
                    TextField("Startraum",text: $startingRoom)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                        .frame(height:50)
                        .frame(maxWidth: .infinity)
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
                                        shortestPath = shortestPathFound
                                    } else {
                                        print("No path found from start to end")
                                        shortestPath = []
                                    }
                                    /*
                                     if let route = shortestRouteBetween(start: startingRoomObject, destination: endingRoomObject, hallways: hallways) {
                                     withAnimation {
                                     resultDistance = route.distance
                                     mapPathVertices = route.path
                                     mapPathDrawnPercentage = 1
                                     }
                                     }
                                     */
                                }
                            }
                            else {
                                startingRoomObject = Room(name: "No room", entrancePoint:  CGPoint(x: 0, y:0))
                            }
                        }
                    Menu{
                        ForEach(rooms, id: \.self){item in
                            Button(item.name){
                                self.startingRoom = item.name
                            }
                        }
                    } label: {
                        VStack(spacing: 10){
                            Image(systemName: "chevron.down")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
                
                HStack{
                    TextField("Zielraum",text: $endingRoom)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(5)
                        .frame(height:50)
                        .frame(maxWidth: .infinity)
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
                                    if (shortestPathFound.count>0)
                                    {
                                        shortestPath = shortestPathFound
                                    } else {
                                        print("No path found from start to end")
                                        shortestPath = []
                                    }
                                    
                                    /*if let route = shortestRouteBetween(start: startingRoomObject, destination: endingRoomObject, hallways: hallways) {
                                     withAnimation {
                                     resultDistance = route.distance
                                     mapPathVertices = route.path
                                     mapPathDrawnPercentage = 1
                                     }
                                     }*/
                                }
                            }
                            else{
                                endingRoomObject = Room(name: "No room", entrancePoint:  CGPoint(x: 0, y:0))
                            }
                        }
                    Menu{
                        ForEach(rooms.sorted{
                            $0.name > $1.name
                        }, id: \.self){item in
                            Button(item.name){
                                self.endingRoom = item.name
                            }
                        }
                    } label: {
                        VStack(spacing: 10){
                            Image(systemName: "chevron.down")
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                }
                .padding(.leading, 10)
                .padding(.trailing, 10)
            }
        }
    }
    
    var customNavigationBar: some View {
        HStack {
            Spacer()
            Image("fhnw_logo_w_claim_de")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
            Spacer()
        }
        .background(Color("fhnw-yellow")) // Customize your background
        .frame(minWidth: 0, maxWidth: .infinity)
        // Add more customization as needed
    }
}

#Preview {
    ContentView()
}
