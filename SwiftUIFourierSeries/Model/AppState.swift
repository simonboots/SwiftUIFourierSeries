import Foundation

struct AppState {
    var time: TimeInterval
    var timerIsRunning: Bool
    var numOfFunctions: Int
    var seriesKind: FourierSeries.Kind
    var series: FourierSeries
    var graph: GraphModel
}
