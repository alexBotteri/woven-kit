import SwiftUI

public struct ConversationView: View {
    @Binding var level: Double
    @Binding var animation: AnimationState
    @State private var yOffset = 0.0
    @State private var xOffset = 0.0
    @State private var listenLevel: Bool = false
    @State private var orange: CGSize = .zero
    @State private var yellow: CGSize = .zero
    let duration: TimeInterval = 0.3
    @State private var scale = 1.0
    
    public init(_ animation: Binding<AnimationState>, level: Binding<Double>) {
        _level = level
        _animation = animation
    }
    
    public var body: some View {
        ZStack {
            Color.beige
            Circle()
                .fill(
                    RadialGradient(colors: [.yellowAccent, .clear], center: .center, startRadius: 0, endRadius: 120 * scale)
                )
                .frame(width: 400 * scale, height: 400 * scale)
                .offset(yellow)
            Circle()
                .fill(
                    RadialGradient(colors: [.orangeAccent, .clear], center: .center, startRadius: 0, endRadius: 60 * scale)
                )
                .frame(width: 120 * scale, height: 120 * scale)
                .offset(orange)
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
            switch animation {
            case .idle:
                listenLevel = false
                withAnimation(.snappy, moveBottomLeft)
            case .listening:
                listenLevel = false
                
                if orange.width == 0 {
                    withAnimation(.snappy(duration: 1), moveBottom)
                    withAnimation(.snappy(duration: 1), moveLeft)
                } else {
                    withAnimation(.snappy(duration: 1), moveBottomLeft)
                }
                withAnimation(.linear(duration: 2).repeatForever().delay(0), moveBottomRight)
            case .talking:
                withAnimation(.snappy(duration: duration), moveBottomCenter)
                listenLevel = true
            }
        }
        .onChange(of: level) { level in
            guard listenLevel else {return}
            withAnimation(.bouncy) {
                orange.height = yOffset - level*120.0
                yellow.height = yOffset - 20 - level*80.0
                scale = level/2 + 1
            }
        }
    }
    
    private var dot: some View {
        Circle()
            .fill(
                RadialGradient(colors: [.beige, .clear], center: .center, startRadius: 0, endRadius: 60 * scale)
            )
            .frame(width: 100, height: 100)
    }
    
    private func moveBottomLeft() {
        orange.width = -xOffset
        orange.height = yOffset
        yellow.width = 60 - xOffset
        yellow.height = yOffset - 20
        scale = 1
    }
    
    private func moveBottomRight() {
        orange.width = xOffset
        orange.height = yOffset
        yellow.width = xOffset - 60
        yellow.height = yOffset - 20
        scale = 1
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
        scale = 1
    }
    
    private func moveLeft() {
        orange.width = -xOffset
        yellow.width = 60 - xOffset
        scale = 1
    }
}

