import SwiftUI

struct ConversationDemoView: View {
    @State private var animation: ConversationView.AnimationState = .idle
    @State private var level: Double = 0
    
    var body: some View {
        ZStack {
            ConversationView($animation, level: $level)
            VStack {
                Button("Stop") {
                    animation = .idle
                }
                Button("Listen") {
                    animation = .listening
                }
                Button("Talk") {
                    animation = .talking
                }
            }
        }
        .task {
            repeat {
                try? await Task.sleep(for: .seconds(0.3))
                level = Double((0...100).randomElement()!)/100
            } while true
        }
    }
}

#Preview {
    ConversationDemoView()
}
