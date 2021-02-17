import Combine
import SwiftUI

struct ConfigView: View {
    @ObservedObject var store: Store
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        // https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/
        Group {
            if verticalSizeClass == .regular && horizontalSizeClass == .compact {
                // iPhone Portrait or iPad 1/3 split view for Multitasking for instance
                // A
                // B
                // C
                VStack {
                    Spacer()
                    Text("V: Regular, H: Compact").padding()
                    Spacer()
                    VStack {
                        ButtonsView(store: store).padding()
                        Spacer()
                        PickerView(store: store).padding()
                    }
                    Spacer()
                }
            } else if verticalSizeClass == .compact && horizontalSizeClass == .compact {
                // some "standard" iPhone Landscape (iPhone SE, X, XS, 7, 8, ...)
                // A B C
                VStack {
                    Spacer()
                    Text("V: Compact, H: Compact").padding()
                    Spacer()
                    HStack {
                        ButtonsView(store: store).padding()
                        Spacer()
                        PickerView(store: store).padding()
                    }
                    Spacer()
                }
            } else if verticalSizeClass == .compact && horizontalSizeClass == .regular {
                // some "bigger" iPhone Landscape (iPhone Xs Max, 6s Plus, 7 Plus, 8 Plus, ...)
                // A B C D
                VStack {
                    Spacer()
                    Text("V: Compact, H: Regular").padding()
                    Spacer()
                    HStack {
                        ButtonsView(store: store)
                        Spacer()
                        PickerView(store: store)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        let timer = Timer(frequency: 0.2)
        let store = Store(kind: .squareWave, numOfFunctions: 10, timer: timer)
        
        return ConfigView(store: store)
    }
}
