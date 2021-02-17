//
//  PickerView.swift
//  SwiftUIFourierSeries
//
//  Created by Jessica Trinh on 2/17/21.
//  Copyright © 2021 Simon Stiefel. All rights reserved.
//

import SwiftUI

struct PickerView: View {
    @ObservedObject var store: Store
    
    var body: some View {
        Picker(selection:
            Binding(
                get: { self.store.state.seriesKind },
                set: { self.store.send(.changeKind($0)) }
            ),
            label: Text(""),
            content: {
                ForEach(FourierSeries.Kind.allCases, id: \.rawValue) { kind in
                    return Text(kind.rawValue).tag(kind)
                }
            }
        )
    }
}

struct PickerView_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Timer(frequency: 0.2)
        let store = Store(kind: .squareWave, numOfFunctions: 10, timer: timer)
        
        return PickerView(store: store)
    }
}
