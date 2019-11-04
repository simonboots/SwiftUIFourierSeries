import SwiftUI

struct GraphView: View {
    @ObservedObject var store: Store
    
    var body: some View {
        return GeometryReader { reader in
            self.makePath(reader)
        }
    }
    
    func makePath(_ reader: GeometryProxy) -> some View {
        var path = Path()
        
        for (x,y) in store.state.graph.ys.reversed().enumerated() {
            // Center vertically
            let y = y + Double(reader.size.height / 2.0)
            if x == 0 {
                path.move(to: CGPoint(x: Double(x), y: y))
            } else {
                path.addLine(to: CGPoint(x: Double(x), y: y))
            }
        }
        
        return path
            .stroke(lineWidth: 1.0)
            .foregroundColor(.primary)
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Timer(frequency: 0.2)
        let store = Store(kind: .squareWave, numOfFunctions: 5, timer: timer)
        
        return GraphView(store: store)
    }
}
