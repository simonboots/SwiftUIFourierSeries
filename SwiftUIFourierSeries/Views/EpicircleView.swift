import SwiftUI

struct EpicircleView: View {
    @ObservedObject var store: Store
    let index: Int
    var function: FourierSeries.Function? {
        guard store.state.series.functions.count > index else { return nil }
        return store.state.series.functions[index]
    }
    
    var radius: CGFloat {
        return abs(function?.amplitude ?? 0.0)
    }
    
    var body: some View {
        let circle = Circle()
            .stroke(lineWidth: 1.0)
            .foregroundColor(.secondary)
            .frame(
                width: radius * 2.0,
                height: radius * 2.0
        )
        
        var path = Path()
        
        if let function = function {
            // Path from center to point on circle
            path.move(to: CGPoint(x: radius, y: radius))
            var point = function.point(at: store.state.time)
            point.x += radius
            point.y += radius
            path.addLine(to: point)
        }
        
        return circle
            .overlay(
                path
                    .stroke(lineWidth: 1.0)
                    .foregroundColor(.primary)
            )
    }
}

struct EpicircleView_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Timer(frequency: 1.0)
        let store = Store(kind: .squareWave, numOfFunctions: 1, timer: timer)
        
        return EpicircleView(store: store, index: 0)
    }
}
