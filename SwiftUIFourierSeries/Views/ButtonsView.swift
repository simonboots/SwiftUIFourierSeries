//
//  ButtonsView.swift
//  SwiftUIFourierSeries
//
//  Created by Jessica Trinh on 2/17/21.
//  Copyright © 2021 Simon Stiefel. All rights reserved.
//

import SwiftUI

struct ButtonsView: View {
    @ObservedObject var store: Store
    
    var body: some View {
        VStack {
            HStack {
                if self.store.state.timerIsRunning {
                    Button("Pause") { self.store.send(.pause) }
                } else {
                    Button("Play") { self.store.send(.play) }
                }
                Button("Reset") { self.store.send(.reset) }
            }
            .padding()

            HStack {
                Text("Number of functions:")
                Button("-") { self.store.send(.decrementnumOfFunctions) }
                    .disabled(self.store.state.numOfFunctions <= 1)
                Text("\(self.store.state.numOfFunctions)")
                Button("+") { self.store.send(.incrementnumOfFunctions) }
            }
            
        }
    }
}

struct ButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Timer(frequency: 0.2)
        let store = Store(kind: .squareWave, numOfFunctions: 10, timer: timer)
        
        return ButtonsView(store: store)
    }
}
