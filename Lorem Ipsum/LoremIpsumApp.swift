//
//  LoremIpsumApp.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-16.
//

import SwiftUI

@main
struct LoremIpsumApp: App {
    var appState = AppState()

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: appState.contentViewModel)
                .environment(appState)
                .frame(minWidth: 400, minHeight: 400)
        }
        .commands {
            CommandGroup(after: .newItem) {
                NewItemCommandsView()
                    .environment(appState)
            }

            CommandGroup(after: .pasteboard) {
                PasteboardCommandsView()
                    .environment(appState)
            }

            CommandGroup(after: .sidebar) {
                SidebarCommandsView()
                    .environment(appState)
            }
        }
    }
}
