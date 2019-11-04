import SwiftUI

struct SeriesView: View {
    @ObservedObject var store: Store
    @State var viewBounds = BoundsData()
    
    struct BoundsData: Identifiable, Equatable {
        let id = UUID()
        var cirlcesBounds: CGRect?
        var graphBounds: CGRect?
    }
    
    struct BoundsPreferenceKey: PreferenceKey {
        typealias Value = BoundsData
        
        static var defaultValue: SeriesView.BoundsData = BoundsData()
        
        static func reduce(value: inout SeriesView.BoundsData, nextValue: () -> SeriesView.BoundsData) {
            let next = nextValue()
            if let nextCircles = next.cirlcesBounds {
                value.cirlcesBounds = nextCircles
            }
            
            if let nextGraph = next.graphBounds {
                value.graphBounds = nextGraph
            }
        }
    }
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                HStack(
                    alignment: VerticalAlignment.center,
                    content: {
                        Spacer()
                            .frame(width: CGFloat(50.0))
                        
                        EpicirclesView(store: self.store)
                            .transformAnchorPreference(key: BoundsPreferenceKey.self, value: .bounds) { (data: inout BoundsData, anchor) in
                                data.cirlcesBounds = geometry[anchor]
                            }
                        Spacer()
                            .frame(width: CGFloat(80.0))
                        GraphView(store: self.store)
                            .transformAnchorPreference(key: BoundsPreferenceKey.self, value: .bounds) { (data: inout BoundsData, anchor) in
                                data.graphBounds = geometry[anchor]
                            }
                    }
                )
                    .overlay(self.pen)
                    .onPreferenceChange(BoundsPreferenceKey.self) { self.viewBounds = $0 }
            }
            
            ConfigView(store: self.store)
        }
    }
    
    private var pen: some View {
        var path = Path()
        
        // Start from Epicircle absolute point
        var point = store.state.series.absolutePointForSeries(at: store.state.time)
        if let epicirclesBounds = viewBounds.cirlcesBounds {
            point.x += epicirclesBounds.midX
            point.y += epicirclesBounds.midY
        }
        path.move(to: point)
        point.x = viewBounds.graphBounds?.minX ?? 0
        path.addLine(to: point)
        
        return path
            .stroke(lineWidth: 1.0)
            .foregroundColor(.red)
    }
}

struct SeriesView_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Timer(frequency: 0.2)
        let store = Store(kind: .squareWave, numOfFunctions: 10, timer: timer)
        
        return SeriesView(store: store)
    }
}
