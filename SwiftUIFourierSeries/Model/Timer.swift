import Combine
import Foundation

final class Timer: ObservableObject {
    
    // MARK: - Properties
    
    private let dt: Double
    private let updatesPerSecond: Double
    private var timer: Foundation.Timer?
    private(set) var time: TimeInterval = 0.0
    let objectWillChange = PassthroughSubject<TimeInterval, Never>()
    var isRunning: Bool {
        return timer?.isValid ?? false
    }
    
    // MARK: - Life cycle
    
    init(frequency: Double = 1.0, unit: Double = 2 * .pi, updatesPerSecond: Double = 30.0) {
        self.updatesPerSecond = updatesPerSecond
        self.dt = unit * frequency / updatesPerSecond
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Methods
    
    func start() {
        let timer = self.timer ?? makeTimer()
        RunLoop.current.add(timer, forMode: .default)
        self.timer = timer
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        self.time = 0.0
    }
    
    // MARK: - Private methods
    
    private func updateTime() {
        time += dt
        objectWillChange.send(time)
    }
    
    private func makeTimer() -> Foundation.Timer {
        let timer = Foundation.Timer(timeInterval: TimeInterval(1.0 / self.updatesPerSecond), repeats: true) { [weak self] (timer) in
            guard let self = self else { return }
            self.updateTime()
        }
        
        return timer
    }
}
