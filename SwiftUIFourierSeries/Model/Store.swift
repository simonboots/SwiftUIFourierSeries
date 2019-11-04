import Combine
import CoreGraphics
import Foundation

final class Store: ObservableObject {

    // MARK: - Types
    
    enum Action {
        case updateTime(Double)
        case changeKind(FourierSeries.Kind)
        case incrementnumOfFunctions
        case decrementnumOfFunctions
        case pause
        case play
        case reset
    }
    
    private enum Constants {
        static let scale: CGFloat = 50.0
    }
    
    // MARK: - Properties
    
    @Published var state: AppState
    private let timer: Timer
    private var cancellable: Cancellable?
    
    // MARK: - Life cycle
    
    init(kind: FourierSeries.Kind, numOfFunctions: Int, timer: Timer) {
        self.timer = timer
        timer.start()
        self.state = AppState(
            time: timer.time,
            timerIsRunning: timer.isRunning,
            numOfFunctions: numOfFunctions,
            seriesKind: kind,
            series: FourierSeries.make(kind, numberOfFunctions: numOfFunctions, scale: Constants.scale),
            graph: GraphModel(maxLength: 1000)
        )
        
        cancellable = timer.objectWillChange.sink(receiveValue: { (time) in
            self.send(.updateTime(time))
        })
    }
    
    func send(_ action: Action) {
        Store.reduce(state: &state, timer: timer, action: action)
    }
    
    static private func reduce(state: inout AppState, timer: Timer, action: Action) {
        switch action {
        case .updateTime(let time):
            state.graph.add(Double(state.series.absolutePointForSeries(at: time).y))
            state.time = time
        case .changeKind(let kind):
            state.series = FourierSeries.make(kind, numberOfFunctions: state.numOfFunctions, scale: Constants.scale)
            state.seriesKind = kind
        case .incrementnumOfFunctions:
            let newNumberOfFunctions = state.numOfFunctions + 1
            state.series = FourierSeries.make(state.seriesKind, numberOfFunctions: newNumberOfFunctions, scale: Constants.scale)
            state.numOfFunctions = newNumberOfFunctions
        case .decrementnumOfFunctions:
            guard state.numOfFunctions > 1 else { return }
            let newNumberOfFunctions = state.numOfFunctions - 1
            state.series = FourierSeries.make(state.seriesKind, numberOfFunctions: newNumberOfFunctions, scale: Constants.scale)
            state.numOfFunctions = newNumberOfFunctions
        case .pause:
            timer.stop()
            state.timerIsRunning = false
        case .play:
            timer.start()
            state.timerIsRunning = true
        case .reset:
            timer.reset()
            state.time = 0.0
            state.graph.removeAll()
        }
    }
}
