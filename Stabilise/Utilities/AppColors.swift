//
//  AppColors.swift
//  Stabilise
//
//  Created by Mariyam Tanveer on 15/11/2024.
//

import SwiftUI

struct AppColors {
    static let primary = Color(hex: "#CE816B")     // Primary color
    static let secondary = Color(hex: "#9B6460")  // Secondary color
    static let textBackground = Color(hex: "#F8F8F8") // Text Background
    static let white = Color(hex: "#FFFFFF")      // White color
    static let black = Color(hex: "#000000")      // Black color
}

// Extend Color to support HEX initialization
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.currentIndex = hex.hasPrefix("#") ? hex.index(after: hex.startIndex) : hex.startIndex
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1.0)
    }
}
