import SwiftUI

@main
struct KollaborateApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}

struct SplashScreenView: View {
    @State private var scale = 0.8
    @State private var opacity = 0.0
    @State private var isActive = false

    var body: some View {
        ZStack {
            Color(red: 0.05, green: 0.05, blue: 0.05).edgesIgnoringSafeArea(.all)

            if isActive {
                ContentView()
            } else {
                VStack {
                    Image("Kollaborate-app-icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 360, height: 360)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .shadow(color: Color("SecondaryAccent").opacity(0.8), radius: 20, x: 0, y: 0)
                }
                .onAppear {
                    withAnimation(.easeIn(duration: 1.5)) {
                        self.opacity = 1.0
                    }
                    withAnimation(.easeInOut(duration: 1.5).delay(0.2).repeatForever(autoreverses: true)) {
                        self.scale = 1.0
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            }
        }
    }
}
