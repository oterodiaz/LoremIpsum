//
//  LoremIpsumApp.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-16.
//

import SwiftUI

@main
struct LoremIpsumApp: App {
    @StateObject var state = AppState()
    @AppStorage("NSFullScreenMenuItemEverywhere") var fullScreenEnabled = false

    let appName = "Lorem Ipsum"

    init() {
         fullScreenEnabled = false
    }

    var body: some Scene {
        Window(appName, id: "main") {
            ContentView()
                .environmentObject(state)
                .environmentObject(state.contentViewState)
                .onAppear {
                    NSWindow.allowsAutomaticWindowTabbing = false
                }
        }
        .defaultSize(width: 550, height: 500)
        .commands {
            CommandGroup(after: .newItem) {
                NewItemCommandsView()
                    .environmentObject(state.contentViewState)
            }

            CommandGroup(after: .pasteboard) {
                PasteboardCommandsView()
                    .environmentObject(state)
            }

            CommandGroup(after: .sidebar) {
                SidebarCommandsView()
                    .environmentObject(state.contentViewState)
            }

            CommandGroup(replacing: .help, addition: {})
        }
    }
}
