//
//  Created by Showmax
//

import SwiftUI

// MARK: - Helpers

@available(iOS 13.0, *)
public extension ShapeStyle where Self == Color {
    static var debug: Color {
    #if DEBUG
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1)
        ).opacity(0.3)
    #else
        return Color(.clear)
    #endif
    }
}
