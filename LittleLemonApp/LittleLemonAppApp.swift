//
//  LittleLemonAppApp.swift
//  LittleLemonApp
//
//  Created by Jarek  on 24/01/2024.
//

import SwiftUI

@main
struct LittleLemonApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            Onboarding().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
