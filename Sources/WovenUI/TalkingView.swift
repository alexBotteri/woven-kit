//
//  SwiftUIView.swift
//  
//
//  Created by Ravil Khusainov on 10.04.24.
//

import SwiftUI

public struct TalkingView: View {
    // Value that controls the level of animated view: 0 - bottom position, 1 - top most position
    @Binding var level: Double
    @State private var yOffset = 0.0
    @State private var xOffset = 0.0
    @State private var started: Bool = false
    @State private var animating: Bool = false
    @State private var orangeYOffset: CGFloat = 0
    @State private var yellowYOffset: CGFloat = 0
    
    public init(_ level: Binding<Double>) {
        _level = level
    }
    
    public var body: some View {
        ZStack {
            Color.beige
            Circle()
                .fill(
                    RadialGradient(colors: [.yellowAccent, .clear], center: .center, startRadius: 0, endRadius: 150)
                )
                .frame(width: 300, height: 300)
                .offset(x: yellowXOffset, y: animating ? yellowYOffset : yOffset - 40)
            Circle()
                .fill(
                    RadialGradient(colors: [.orangeAccent, .clear], center: .center, startRadius: 0, endRadius: 70)
                )
                .frame(width: 130, height: 130)
                .offset(x: orangeXOffset, y: animating ? orangeYOffset : yOffset)
            Rectangle()
                .fill(.ultraThinMaterial)
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                yOffset = proxy.frame(in: .global).midY
                                xOffset = proxy.frame(in: .global).midX
                                yellowYOffset = yOffset - 40
                                orangeYOffset = yOffset
                            }
                    }
                )
                .opacity(0.7)
        }
        .ignoresSafeArea()
        .animation(.easeInOut, value: started)
        .task {
            try? await Task.sleep(for: .seconds(1))
            started.toggle()
            try? await Task.sleep(for: .seconds(0.6))
            animating.toggle()
        }
        .onChange(of: level) { value in
            withAnimation(.easeInOut) {
                orangeYOffset = yOffset - level*120.0
                yellowYOffset = yOffset - 40 - level*80.0
            }
        }
    }
    
    private var orangeXOffset: CGFloat {
        started ? 0 : -xOffset
    }
    
    private var yellowXOffset: CGFloat {
        started ? 0 : 90 - xOffset
    }
}

struct TestTalkingView: View {
    @State private var level: Double = 0
    
    var body: some View {
        TalkingView($level)
            .task {
                repeat {
                    try? await Task.sleep(for: .seconds(1))
                    level = Double((0...100).randomElement()!)/100
                } while true
            }
    }
}

#Preview {
    TestTalkingView()
}
