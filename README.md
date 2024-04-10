
## Adding to the project

Add `https://github.com/partofinc/woven-kit.git` url to *Package Dependecies* of your Xcode project. Use **main** branch.

## Usage

1. Import `WowenUI` framework.
2. Insert `ListeningView()` into `ZStack`

### Examples

```Swift
import SwiftUI
import WovenUI

struct ContentView: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            ListeningView()
            Button {
                
            } label: {
                Image(systemName: "mic.circle")
                    .font(.largeTitle)
            }
            .padding()
        }
    }
}
```

```Swift
import SwiftUI
import WovenUI
import WovenHelpers

struct ContentView: View {
    @StateObject private var mic = MicrophoneLevels()
    @State private var started: Bool = false
    private let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TalkingView($mic.currentLevel, started: $started)
            VStack {
                Text(mic.currentLevel, format: .number)
                Button {
                    mic.start()
                    started.toggle()
                } label: {
                    Image(systemName: "mic.circle")
                        .font(.largeTitle)
                }
            }
            .padding()
        }
        .onReceive(timer, perform: { _ in
            mic.updateLevels()
        })
        .onAppear(perform: {
            mic.setUp()
        })
    }
}
```
