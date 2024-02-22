//
//  FHNWNavigationBar.swift
//  roomfinder
//
//  Created by Pascal Köchli on 15.02.2024.
//

import Foundation
import SwiftUI

struct FHNWNavigationBar: View {
    var body: some View {
        HStack {
            Spacer()
            VStack (spacing:0){
                Image("fhnw_logo_w_claim_de")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                Text("Roomfinder")
                    .font(.custom("Inter", size: 22.0))
            }
            Spacer()
        }
        .background(Color("fhnw-yellow"))
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}
