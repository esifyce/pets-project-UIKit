//
//  CardView.swift
//  slotsUI
//
//  Created by Sabir Myrzaev on 19.04.2021.
//  Copyright © 2021 Sabir. All rights reserved.
//

import SwiftUI

struct CardView: View {
    
    @Binding var symbols:String
    @Binding var background:Color
    
    var body: some View {
        Image(symbols).resizable().aspectRatio(1, contentMode: .fit).background(background.opacity(0.5)).cornerRadius(20)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(symbols: Binding.constant("cherry"), background: Binding.constant(Color.green))
    }
}
