import SwiftUI

extension Font {
    static func an(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.custom("Arial", size: size).weight(weight)
    }
}
