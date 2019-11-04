import Combine
import SwiftUI

struct EpicirclesView: View {
    @ObservedObject var store: Store
    
    var body: some View {
        ZStack {
            ForEach(0..<self.store.state.series.functions.count, id: \.self) { index in
                EpicircleView(store: self.store, index: index)
                    .offset(self.store.state.series.absolutePoint(at: self.store.state.time, forFunctionAt: index).asCGSize)
            }
        }
    }
}

struct EpicirclesView_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Timer(frequency: 0.2)
        let store = Store(kind: .squareWave, numOfFunctions: 5, timer: timer)
        
        return EpicirclesView(store: store)
    }
}
