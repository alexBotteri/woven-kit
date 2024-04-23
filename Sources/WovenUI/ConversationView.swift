import SwiftUI

public struct ConversationView: View {
    @Binding var level: Double
    @Binding var animation: AnimationState
    @State private var yOffset = 0.0
    @State private var xOffset = 0.0
    @State private var listenLevel: Bool = false
    @State private var orange: CGSize = .zero
    @State private var yellow: CGSize = .zero
    
    public init(_ animation: Binding<AnimationState>, level: Binding<Double>) {
        _level = level
        _animation = animation
    }
    
    public var body: some View {
        ZStack {
            Color.beige
            Circle()
                .fill(
                    RadialGradient(colors: [.yellowAccent, .clear], center: .center, startRadius: 0, endRadius: 120)
                )
                .frame(width: 300, height: 300)
                .offset(yellow)
            Circle()
                .fill(
                    RadialGradient(colors: [.orangeAccent, .clear], center: .center, startRadius: 0, endRadius: 60)
                )
                .frame(width: 120, height: 120)
                .offset(orange)
            dot
                .offset(x: 100 - xOffset, y: yOffset - 100)
            dot
                .offset(x: xOffset - 90, y: yOffset - 120)
            Rectangle()
                .fill(.ultraThinMaterial)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                yOffset = proxy.frame(in: .global).midY
                                xOffset = proxy.frame(in: .global).midX
                                moveBottomLeft()
                            }
                    }
                )
                .opacity(0.7)
        }
        .ignoresSafeArea()
        .task(id: animation) {
            try? await Task.sleep(for: .seconds(0.01))
            switch animation {
            case .idle:
                listenLevel = false
                withAnimation(.easeInOut, moveBottomLeft)
            case .listening:
                listenLevel = false
                let duration: TimeInterval = 0.3
                if orange.width == 0 {
                    withAnimation(.easeInOut(duration: duration), moveBottom)
                    try? await Task.sleep(for: .seconds(duration))
                    withAnimation(.easeInOut(duration: 1.5), moveLeft)
                    try? await Task.sleep(for: .seconds(2.2))
                } else {
                    withAnimation(.easeInOut(duration: duration), moveBottomLeft)
                    try? await Task.sleep(for: .seconds(duration))
                }
                withAnimation(.easeInOut(duration: 3).repeatForever().delay(0.7), moveBottomRight)
            case .talking:
                let duration: TimeInterval = 0.3
                withAnimation(.easeInOut(duration: duration), moveBottomCenter)
                try? await Task.sleep(for: .seconds(duration))
                listenLevel = true
            }
        }
        .onChange(of: level) { level in
            guard listenLevel else {return}
            withAnimation(.easeInOut) {
                orange.height = yOffset - level*120.0
                yellow.height = yOffset - 40 - level*80.0
            }
        }
    }
    
    private var dot: some View {
        Circle()
            .fill(
                RadialGradient(colors: [.beige, .clear], center: .center, startRadius: 0, endRadius: 60)
            )
            .frame(width: 100, height: 100)
    }
    
    private func moveBottomLeft() {
        orange.width = -xOffset
        orange.height = yOffset
        yellow.width = 90 - xOffset
        yellow.height = yOffset - 20
    }
    
    private func moveBottomRight() {
        orange.width = xOffset
        orange.height = yOffset
        yellow.width = xOffset - 90
        yellow.height = yOffset - 20
    }
    
    private func moveBottomCenter() {
        orange.width = 0
        orange.height = yOffset
        yellow.width = 0
        yellow.height = yOffset - 20
    }
    
    private func moveBottom() {
        orange.height = yOffset
        yellow.height = yOffset - 20
    }
    
    private func moveLeft() {
        orange.width = -xOffset
        yellow.width = 90 - xOffset
    }
}

