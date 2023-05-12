//
//  companycontrolApp.swift
//  companycontrol
//
//  Created by Ângelo Melo on 10/05/2023.
//

import SwiftUI
import Firebase

@main
struct companycontrolApp: App {
    
    @StateObject var dataManager = DataManager()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            AuthView()
        }
    }
}
