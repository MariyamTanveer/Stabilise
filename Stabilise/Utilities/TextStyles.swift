//
//  TextStyles.swift
//  Stabilise
//
//  Created by Mariyam Tanveer on 17/11/2024.
//

import SwiftUI

struct TextStyles {
    static func styledBody(size: CGFloat = 18, color: Color = .primary, lineSpacing: CGFloat = 6, isBold: Bool = false) -> some ViewModifier {
        TextModifier(font: .system(size: size, weight: isBold ? .bold : .regular), color: color, lineSpacing: lineSpacing)
    }

    static func styledHeadline(size: CGFloat = 22, color: Color = .primary, lineSpacing: CGFloat = 10, isBold: Bool = true) -> some ViewModifier {
        TextModifier(font: .system(size: size, weight: isBold ? .bold : .regular), color: color, lineSpacing: lineSpacing)
    }

    static func customText(size: CGFloat, weight: Font.Weight = .regular, color: Color = .primary, lineSpacing: CGFloat = 6) -> some ViewModifier {
        TextModifier(font: .system(size: size, weight: weight), color: color, lineSpacing: lineSpacing)
    }
}

struct TextModifier: ViewModifier {
    var font: Font
    var color: Color
    var lineSpacing: CGFloat

    func body(content: Content) -> some View {
        content
            .font(font)
            .foregroundColor(color)
            .lineSpacing(lineSpacing)
    }
}

