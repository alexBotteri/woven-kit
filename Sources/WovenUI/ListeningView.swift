import SwiftUI

public struct ListeningView: View {
    let started: Bool
    @State private var yOffset = 0.0
    @State private var xOffset = 0.0
    @State private var left: Bool = true
    
    public var body: some View {
        ZStack {
            Color.beige
            Circle()
                .fill(
                    RadialGradient(colors: [.yellowAccent, .clear], center: .center, startRadius: 0, endRadius: 120)
                )
                .frame(width: 300, height: 300)
                .offset(x: yellowXOffset, y: yOffset-20)
            Circle()
                .fill(
                    RadialGradient(colors: [.orangeAccent, .clear], center: .center, startRadius: 0, endRadius: 60)
                )
                .frame(width: 120, height: 120)
                .offset(x: orangeXOffset, y: yOffset)
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
                            }
                    }
                )
                .opacity(0.7)
        }
        .ignoresSafeArea()
        .animation(.easeInOut(duration: 3).repeatForever().delay(0.7), value: left)
        .task {
            try? await Task.sleep(for: .seconds(1))
            if started {
                left.toggle()
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
    
    private var orangeXOffset: CGFloat {
        left ? -xOffset : xOffset
    }
    
    private var yellowXOffset: CGFloat {
        left ? 90 - xOffset : xOffset - 90
    }
}

#Preview {
    ListeningView(started: false)
}
