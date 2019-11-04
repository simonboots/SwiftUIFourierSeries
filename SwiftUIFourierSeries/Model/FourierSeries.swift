import Foundation
import CoreGraphics
import Combine

struct FourierSeries {
    
    // MARK: - Types
    
    struct Function {
        var amplitude: CGFloat
        var frequency: CGFloat
        var phase: CGFloat
        
        func point(at time: TimeInterval) -> CGPoint {
            let x = amplitude * cos(CGFloat(time) * frequency + phase)
            let y = amplitude * -sin(CGFloat(time) * frequency + phase)
            
            return CGPoint(x: x, y: y)
        }
    }
    
    // MARK: - Properties
    
    let functions: [Function]
        
    // MARK: - Life cycle
    
    init(functions: [Function]) {
        self.functions = functions
    }
    
    func absolutePoint(at time: TimeInterval, forFunctionAt index: Int) -> CGPoint {
        return functions.prefix(index).reduce(CGPoint(x: 0.0, y: 0.0)) { (result, function) -> CGPoint in
            return CGPoint(x: result.x + function.point(at: time).x, y: result.y + function.point(at: time).y)
        }
    }
    
    func absolutePointForSeries(at time: TimeInterval) -> CGPoint {
        return absolutePoint(at: time, forFunctionAt: functions.count)
    }
}

extension FourierSeries {
    
    enum Kind: String, CaseIterable {
        case squareWave = "Square Wave"
        case sawTooth = "Saw Tooth"
        case triangle = "Triangle"
        case pulse = "Pulse"
    }
    
    static func make(_ kind: Kind, numberOfFunctions: Int, scale: CGFloat) -> FourierSeries {
        let f: (Int, CGFloat) -> FourierSeries
        switch kind {
        case .squareWave:
            f = squareWave
        case .sawTooth:
            f = sawTooth
        case .triangle:
            f = triangle
        case .pulse:
            f = pulse
        }
        
        return f(numberOfFunctions, scale)
    }
    
    static func squareWave(numberOfFunctions: Int, scale: CGFloat = 1.0) -> FourierSeries {
        let functions = (0..<numberOfFunctions).map { index -> Function in
            let i = CGFloat(index+1)
            
            let amplitude = 1 / (2 * i - 1)
            let frequency = 2 * i - 1
            return Function(amplitude: scale * amplitude, frequency: frequency, phase: 0.0)
        }
        
        return FourierSeries(functions: functions)
    }
    
    static func sawTooth(numberOfFunctions: Int, scale: CGFloat = 1.0) -> FourierSeries {
        let functions = (0..<numberOfFunctions).map { index -> Function in
            let i = CGFloat(index+1)
            let sign = CGFloat((index % 2 == 0 ? -1 : 1))
            
            let amplitude = sign / i
            let frequency = i
            return Function(amplitude: scale * amplitude, frequency: frequency, phase: 0.0)
        }
        
        return FourierSeries(functions: functions)
    }
    
    static func triangle(numberOfFunctions: Int, scale: CGFloat = 1.0) -> FourierSeries {
        let functions = (0..<numberOfFunctions).map { index -> Function in
            let i = CGFloat(index+1)
            let sign = CGFloat((index % 2 == 0 ? 1 : -1))
            
            let amplitude = sign / ((2 * i - 1) * (2 * i - 1))
            let frequency = 2 * i - 1
            return Function(amplitude: scale * amplitude, frequency: frequency, phase: 0.0)
        }
        
        return FourierSeries(functions: functions)
    }
    
    static func pulse(numberOfFunctions: Int, scale: CGFloat = 1.0) -> FourierSeries {
        let functions = (0..<numberOfFunctions).map { index -> Function in
            let i = CGFloat(index+1)
            
            let amplitude = CGFloat(0.1)
            let frequency = i
            return Function(amplitude: scale * amplitude, frequency: frequency, phase: 0.0)
        }
        
        return FourierSeries(functions: functions)
    }
}

extension CGPoint {
    var asCGSize: CGSize {
        CGSize(width: x, height: y)
    }
}
