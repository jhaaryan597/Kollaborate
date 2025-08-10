import SwiftUI

struct KollaborateTextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .regular))
            .padding(12)
            .background(Color("SurfaceHighlight"))
            .cornerRadius(12)
            .foregroundColor(Color("PrimaryText"))
            .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 5)
            .padding(.horizontal, 24)
    }
}
