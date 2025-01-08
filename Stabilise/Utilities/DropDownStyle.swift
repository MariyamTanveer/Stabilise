//
//  DropDownStyle.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 02.01.25.
//


import SwiftUI

struct DropDownStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 22)) // Set font size to 24
            .padding()
            .background(Color(AppColors.textBackground))
            .cornerRadius(20)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(AppColors.secondary), lineWidth: 1))
    }
}

extension View {
    func dropDownStyle() -> some View {
        self.modifier(DropDownStyle())
    }
}
