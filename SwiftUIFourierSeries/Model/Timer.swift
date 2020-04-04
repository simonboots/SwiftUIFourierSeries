import Combine
import UIKit

final class Timer: ObservableObject {
    
    // MARK: - Properties
    
    let objectWillChange = PassthroughSubject<TimeInterval, Never>()

    var isRunning: Bool {
        return !displayLink.isPaused
    }
    
    private let frequency: Double
    private let unit: Double
    private(set) var time: TimeInterval = 0.0
    
    private lazy var displayLink: CADisplayLink = {
        let displayLink = CADisplayLink(target: self, selector: #selector(updateTime))
        displayLink.add(to: .current, forMode: .default)
        return displayLink
    }()
    
    private var dt: Double {
        return unit * frequency * displayLink.duration
    }
    
    // MARK: - Life cycle
    
    init(frequency: Double = 1.0, unit: Double = 2 * .pi) {
        self.frequency = frequency
        self.unit = unit
    }
    
    deinit {
        stop()
    }
    
    // MARK: - Methods
    
    func start() {        
        displayLink.isPaused = false
    }
    
    func stop() {
        displayLink.isPaused = true
    }
    
    func reset() {
        self.time = 0.0
    }
    
    // MARK: - Private methods
    
    @objc private func updateTime() {
        time += dt
        objectWillChange.send(time)
    }
}
