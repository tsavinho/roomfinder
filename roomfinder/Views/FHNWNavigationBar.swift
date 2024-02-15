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
            Image("fhnw_logo_w_claim_de")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 50)
            Spacer()
        }
        .background(Color("fhnw-yellow"))
        .frame(minWidth: 0, maxWidth: .infinity)
    }
}
