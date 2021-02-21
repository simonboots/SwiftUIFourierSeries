import Combine
import SwiftUI

struct ConfigView: View {
    @ObservedObject var store: Store
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        // https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/
            if verticalSizeClass == .regular && horizontalSizeClass == .compact {
                // iPhone Portrait or iPad 1/3 split view for Multitasking for instance
                // A
                // B
                // C
                VStack {
                    VStack {
                        ButtonsView(store: store).padding()
                        PickerView(store: store).padding()
                    }
                }
            } else {
                // Landscape layout for all other size class combinations
                // A B C
                VStack {
                    HStack {
                        ButtonsView(store: store).padding()
                        PickerView(store: store).padding()
                    }
                }
            }
        
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Timer(frequency: 0.2)
        let store = Store(kind: .squareWave, numOfFunctions: 10, timer: timer)
        
        return Group {
            ConfigView(store: store)
            ConfigView(store: store)
                .previewDevice("iPhone 12 Pro Max")
                .previewLayout(.device)
            ConfigView(store: store)
                .previewDevice("iPhone 12 Pro Max")
                .previewLayout(.device)
        }
    }
}
