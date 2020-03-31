//
//  HalfModalView.swift
//  HalfModalView
//
//  Created by Frank Bara on 3/29/20.
//  Copyright © 2020 BaraLabs. All rights reserved.
//

import SwiftUI

struct HalfModalView<Content: View>: View {
    
    @GestureState private var dragState = DragState.inactive
    @Binding var isShown: Bool
    
    
    private func onDragEnded(drag: DragGesture.Value) {
        //If we pass 2/3 of the view height, continue
        let dragThreshold = modalHeight * (2/3)
        if drag.predictedEndTranslation.height > dragThreshold || drag.translation.height > dragThreshold {
            isShown = false
        }
    }
    
    var modalHeight: CGFloat = 400
    var content: () -> Content
    
    var body: some View {
        
        let drag = DragGesture()
            .updating($dragState) { drag, state, translation in
                state = .dragging(translation: drag.translation)
        }
        
        return Group {
            ZStack {
                //Background
                Spacer()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
                    //Creates the darkness of the background when moving the model up or down
                    .background(isShown ? Color.black.opacity(0.5 * fraction_progress(lowerLimit: 0, upperLimit: Double(modalHeight), current: Double(dragState.translation.height), inverted: true)) : Color.clear)
                    //Animate the color changes
                    .animation(.interpolatingSpring(stiffness: 100.0, damping: 30.0))
                    //.animation(.interpolatingSpring(stiffness: 100.0, damping: 30.0, initialVelocity: 10.0))
                    //Tap gesture to hide view when tapping anywhere outside the model view
                    .gesture(TapGesture().onEnded { _ in
                        self.isShown = false
                    })
                
                //Forground
                VStack {
                    Spacer()
                    ZStack {
                        Color.white.opacity(1.0)
                            .frame(width: UIScreen.main.bounds.size.width, height: modalHeight)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        
                        //Put content directly on top of the white color
                        self.content()
                            .padding()
                            .padding(.bottom, 60)
                            .frame(width: UIScreen.main.bounds.size.width, height: modalHeight)
                            .clipped()
                    }
                        //Offset in y dimension depends on if iShown is true or false
                        .offset(y: isShown ? ((self.dragState.isDragging && dragState.translation.height >= 1) ? dragState.translation.height : 0) : modalHeight)
                        //Show animation
                        .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0))
                        //Add the gesture to the dragModal
                        .gesture(drag)
                }
                
            }.edgesIgnoringSafeArea(.all)
        }
    }
}


enum DragState {
    case inactive
    case dragging(translation: CGSize)
    
    var translation: CGSize {
        switch self {
        case .inactive:
            return .zero
        case .dragging(let translation):
            return translation
        }
    }
    
    var isDragging: Bool {
        switch self {
        case .inactive:
            return false
        case .dragging:
            return true
        }
    }
}


func fraction_progress(lowerLimit: Double = 0, upperLimit: Double, current: Double, inverted: Bool = false) -> Double {
    var val: Double = 0
    
    if current >= upperLimit {
        val = 1
    } else if current <= lowerLimit {
        val = 0
    } else {
        val = (current - lowerLimit)/(upperLimit -  lowerLimit)
    }
    
    if inverted {
        return 1 - val
    } else {
        return val
    }
}
