
## Adding to the project

Add `https://github.com/partofinc/woven-kit.git` url to *Package Dependecies* of your Xcode project. Use **main** branch.

## Usage

1. Import `WowenUI` framework.
2. Insert `ListeningView()` into `ZStack`

### Example

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
