//
//  RainyDaysApp.swift
//  RainyDays
//
//  Created by Christin Lacey on 5/8/25.
//

import SwiftUI

@main
struct RainyDaysApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
