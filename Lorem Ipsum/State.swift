//
//  AppState.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-03-19.
//

import SwiftUI

class AppState: ObservableObject {
    var contentViewState = ContentViewState()
}

class ContentViewState: ObservableObject {
    @Published var text = ""
    @Published var showingPreferences = false
    @Published var lipsum = LipsumGenerator()
    var timer: Timer?
    
    var regenerateTextDisabled: Bool {
        lipsum.unit == .words &&
        lipsum.beginWithLoremIpsum &&
        lipsum.amount <= 17
    }

    init() {
        regenerateText()
    }

    func copyText() {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)
    }

    func regenerateText() {
        text = lipsum.generateText()
    }

}
