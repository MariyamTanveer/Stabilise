//
//  HeaderStyle.swift
//  Stabilise
//
//  Created by Mariyam Tanveer on 15/11/2024.
//

import SwiftUI

struct HeaderView: View {
    var text: String
    var backgroundColor: Color = AppColors.primary
    var textColor: Color = .white

    var body: some View {
        ZStack {
            backgroundColor // Background spanning full height
                .frame(maxWidth: .infinity, maxHeight: 70) // Fixed height of 20

            Text(text)
                .font(.system(size: 44, weight: .semibold, design: .default)) // Large font for the header
                .fontWeight(.bold) // Bold font
                .foregroundColor(textColor) // Text color
                .padding(.horizontal) // Horizontal padding for text
        }
        .frame(maxWidth: .infinity, maxHeight: 70) // Ensure header has a fixed height
    }
}
