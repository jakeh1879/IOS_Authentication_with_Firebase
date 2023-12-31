//
//  auth_app_testApp.swift
//  auth_app_test
//
//  Created by Jacob Hefele on 7/15/23.
//

import SwiftUI
import Firebase

@main
struct auth_app_testApp: App {
    @StateObject var viewModel = AuthViewModel() //initialized in one place for use thoughout. look into
    
    
    init() {
        FirebaseApp.configure() //must be done to launch app
    }
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel) //injects object into environment
        }
    }
}
