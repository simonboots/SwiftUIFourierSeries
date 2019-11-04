final class GraphModel {
    
    // MARK: - Properties
    
    private let maxLength: Int
    private(set) var ys = [Double]()
    
    // MARK: - Life cycle
    
    init(maxLength: Int) {
        self.maxLength = maxLength
    }
    
    // MARK: - Methods
    
    func add(_ y: Double) {
        ys.append(y)
        if ys.count > maxLength {
            ys = ys.suffix(maxLength)
        }
    }
    
    func removeAll() {
        ys.removeAll()
    }
}
