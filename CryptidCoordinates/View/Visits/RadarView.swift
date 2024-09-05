import SwiftUI

struct RadarView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var angle: Double = 0
    @State private var scaleCircle: CGFloat = 1
    
    var main: Color {
        if colorScheme == .dark {
            return .black
        } else {
            return .white
        }
    }
    
    var shadow: Color {
        if colorScheme == .dark {
            return .white
        } else {
            return .black
        }
    }
    
    var body: some View {
        let gradient = Gradient(stops: [
            .init(color: main, location: 0.0),
            .init(color: main, location: 0.4),
            .init(color: main, location: 0.7),
            .init(color: Color("AccentColor"), location: 1.0)
        ])
        
        ZStack {
            Group {
                Circle()
                    .stroke(Color.clear, lineWidth: 1)
                    .frame(width: 200, height: 200)
                    .background(AngularGradient(gradient: gradient, center: .center, angle: .degrees(0)))
                    .clipShape(Circle())
                    .opacity(0.8)
                    .shadow(color: shadow.opacity(0.2), radius: 10, x: 0, y: 5)
                
                Path { path in
                    path.move(to: CGPoint(x: 100, y: 100))
                    path.addLine(to: CGPoint(x: 200, y: 100))
                }
                .stroke(Color("AccentColor"), lineWidth: 4)
            }.rotation3DEffect(.degrees(angle), axis: (x: 0, y: 0, z: 1))
            
            
            ZStack {
                Dot(point: CGPoint(x: 70, y: 70))
                
                Dot(point: CGPoint(x: 50, y: 100))

                Color("AccentColor")
                    .frame(width: 15, height: 15)
                    .clipShape(Circle())
                    .position(x: 101, y: 101)
                
                Dot(point: CGPoint(x: 60, y: 150))
                
                Dot(point: CGPoint(x: 175, y: 100))
                
                Dot(point: CGPoint(x: 47, y: 47))
                
            }
        }
        .frame(width: 200, height: 200)
        .onAppear(perform: {
            Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                withAnimation(Animation.linear.repeatForever(autoreverses: false)) {
                    self.angle += 20
                }
            }
        })
    }
}

#Preview {
    RadarView()
}

struct Dot: View {
    var point: CGPoint
    @State private var scale = 1.0
    @State private var opacity = 1.0
    
    let delay = Double.random(in: 0...0.5)
    
    var body: some View {
        Color("AccentColor")
            .frame(width: 10, height: 10)
            .clipShape(Circle())
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(Animation.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                        opacity = 0.0
                        scale = 0.0
                    }
                }
            }
            .position(x: point.x, y: point.y)
    }
}
