import Combine
import SwiftUI

struct ConfigView: View {
    @ObservedObject var store: Store
    
    var body: some View {
        HStack {
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
            
            Spacer()
            
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
        .padding()
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Timer(frequency: 0.2)
        let store = Store(kind: .squareWave, numOfFunctions: 10, timer: timer)
        
        return ConfigView(store: store)
    }
}
