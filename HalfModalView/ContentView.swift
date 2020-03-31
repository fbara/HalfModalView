//
//  ContentView.swift
//  HalfModalView
//
//  Created by Frank Bara on 3/29/20.
//  Copyright © 2020 BaraLabs. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var halfModalShown = false
    
    var body: some View {
        ZStack {
            Button(action: {
                self.halfModalShown.toggle()
            }) {
                Text("Show Card")
            }
            
            HalfModalView(isShown: $halfModalShown) {
                Text("Hello Modal!")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
