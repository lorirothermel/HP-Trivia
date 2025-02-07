//
//  HP_TriviaApp.swift
//  HP Trivia
//
//  Created by Lori Rothermel on 1/21/25.
//

import SwiftUI

@main
struct HP_TriviaApp: App {
    @StateObject private var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .task {
                    await store.loadProducts()
                }  // task
        }
    }
}
