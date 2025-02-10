//
//  LanguageManager.swift
//  Stabilise
//
//  Created by Mariyam Taveer on 10.02.25.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
            
            // Reload the app’s root view
            reloadApp()
        }
    }
    
    init() {
        let savedLanguage = UserDefaults.standard.array(forKey: "AppleLanguages")?.first as? String
        self.selectedLanguage = savedLanguage ?? Locale.current.language.languageCode?.identifier ?? "en"
    }
    
    private func reloadApp() {
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return }
            
            window.rootViewController = UIHostingController(rootView: ContentView())
            window.makeKeyAndVisible()
        }
    }
}
