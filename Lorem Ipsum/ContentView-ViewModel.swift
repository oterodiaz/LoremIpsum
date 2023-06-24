//
//  ContentView-ViewModel.swift
//  Lorem Ipsum
//
//  Created by Otero Díaz on 2023-06-22.
//

import SwiftUI
import Observation

@Observable
class ContentViewModel {
    var text = ""
    var lipsum = LipsumGenerator()
    var timer: Timer? = nil

    var regenerateTextDisabled: Bool {
        lipsum.unit == .words &&
        lipsum.beginWithLoremIpsum &&
        lipsum.amount <= 17
    }

    init() {
        regenerateText()
    }

    func copyText() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = text
    }

    func regenerateText() {
        text = lipsum.generateText()
    }

}
