//
//  SmallButton.swift
//  Stabilise
//
//  Created by Mariyam Tanveer on 17/11/2024.
//

import SwiftUI

struct SmallButton: ButtonStyle {
    var backgroundColor: Color = AppColors.primary
    var foregroundColor: Color = .white
    var cornerRadius: CGFloat = 20
    var padding: CGFloat = 15
    var fontSize: CGFloat = 24
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity) // Full-width button
            .padding(padding)
            .background(backgroundColor)
            .foregroundColor(foregroundColor)
            .cornerRadius(cornerRadius)
            .font(.system(size: fontSize, weight: .bold, design: .default)) // Font size and bold text
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0) // Tap animation
            .opacity(configuration.isPressed ? 0.8 : 1.0) // Pressed state opacity
    }
}
